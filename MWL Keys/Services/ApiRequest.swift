//
//  RestApiService.swift
//  MWL Keys
//
//  Created by Marcus Lowe on 9/29/19.
//  Copyright © 2019 Marcus Lowe. All rights reserved.
//

import Foundation

enum Service {
    case authorization
    case main
}
/* enum APIError: Error {
    case responseProblem
    case decodingProblem
    case encodingProblem
} */

struct APIError : Error {
    var message: String?;
    
    init(_ message: String) {
        self.message = message;
    }
}

struct APIRequest {
    static let authKey = "Basic Zm9vQ2xpZW50SWRQYXNzd29yZDpzZWNyZXQ=";
    static let authorizationBaseURL = ProcessInfo.processInfo.environment["AUTHORIZATION_BASE_URL"]!;
    static let mainURL = ProcessInfo.processInfo.environment["CORE_BASE_URL"]!;
    
    static let INTERNAL_ERROR = APIError("Internal Error Has Occurred");
    
    func getToken(_ username: String, password: String, completion: @escaping(Result<Token, APIError>) -> Void) {
        print(APIRequest.authorizationBaseURL);
        guard let resourceURL = URL(string: APIRequest.authorizationBaseURL + "oauth/token") else {fatalError()};
        do {
             let data = "grant_type=password&username=\(username)&password=\(password)".data(using: .utf8);
            var urlRequest = URLRequest(url: resourceURL);
            urlRequest.httpMethod = "POST";
            urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type");
            urlRequest.addValue(APIRequest.authKey, forHTTPHeaderField: "Authorization");
            urlRequest.httpBody = data;
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
                guard let httpResponse = response as? HTTPURLResponse,
                    let jsonData = data else {
                        completion(.failure(APIRequest.INTERNAL_ERROR));
                        return;
                }
                
                do {
                    switch httpResponse.statusCode {
                        case 200:
                            let tokenData = try JSONDecoder().decode(Token.self, from: jsonData);
                            completion(.success(tokenData));
                        case 400:
                            completion(.failure(APIError("Invalid username and/or password")));
                        default:
                            completion(.failure(APIRequest.INTERNAL_ERROR));
                    }
                } catch {
                     completion(.failure(APIRequest.INTERNAL_ERROR));
                }
            }
            dataTask.resume();
        }
    }
    
    func postVehicleRegistration(_ registration: VehicleRegistration, completion: @escaping(Result<Registration, APIError>) -> Void) {
           do {
            guard let resourceURL = URL(string: APIRequest.mainURL
                + "vehicleregistrations") else {fatalError()};
            print(resourceURL.absoluteString)
               var urlRequest = URLRequest(url: resourceURL)
               urlRequest.httpMethod = "POST";
               urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("Bearer " + TokenService().getAccessToken(), forHTTPHeaderField: "Authorization")
               urlRequest.httpBody = try JSONEncoder().encode(registration);
            print(String(data: urlRequest.httpBody!, encoding: .utf8)!)
               let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
                   guard let httpResponse = response as? HTTPURLResponse,
                       let jsonData = data else {
                        completion(.failure(APIRequest.INTERNAL_ERROR));
                           return
                   }
                   do {
                    switch httpResponse.statusCode {
                    case 201:
                        let registration = try JSONDecoder().decode(Registration.self, from: jsonData);
                        completion(.success(registration));
                    case 400:
                        completion(.failure(APIError("Bad Request")));
                    default:
                        completion(.failure(APIRequest.INTERNAL_ERROR));
                    };
                       
                   } catch {
                    completion(.failure(APIRequest.INTERNAL_ERROR));
                   }
               }
               dataTask.resume();
           } catch {
            completion(.failure(APIRequest.INTERNAL_ERROR));
           }
       }
    
    
    func getRegistrationByVIN(_ vin: String,
                                completion: @escaping(Result<Registration, APIError>) -> Void) {
        guard let resourceURL = URL(string: APIRequest.mainURL
            + "vehicleregistrations/vin/" + vin) else {fatalError()};
              do {
                var urlRequest = URLRequest(url: resourceURL);
                  urlRequest.httpMethod = "GET";
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type");
                urlRequest.addValue("Bearer " + TokenService().getAccessToken(), forHTTPHeaderField: "Authorization");
                  let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
                      guard let httpResponse = response as? HTTPURLResponse,
                          let jsonData = data else {
                            completion(.failure(APIRequest.INTERNAL_ERROR));
                            return;
                      }
                      do {
                         switch httpResponse.statusCode {
                         case 200:
                                let registration = try JSONDecoder().decode(Registration.self, from: jsonData);
                                completion(.success(registration));
                         case 400:
                            completion(.failure(APIError("Bad Request")));
                         default:
                            completion(.failure(APIRequest.INTERNAL_ERROR));
                        };
                      } catch {
                        completion(.failure(APIRequest.INTERNAL_ERROR));
                      }
                  }
                  dataTask.resume();
              }
          }
    
   
}

struct KeyOrderAPI {
    func postKeyRequest(_ keyRequest: KeyRequest, completion: @escaping(Result<KeyOrder, APIError>) -> Void) {
           do {
            guard let resourceURL = URL(string: APIRequest.mainURL
               + "keyrequests") else {fatalError()};
               var urlRequest = URLRequest(url: resourceURL);
               urlRequest.httpMethod = "POST";
               urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type");
               urlRequest.addValue("Bearer " + TokenService().getAccessToken(), forHTTPHeaderField: "Authorization");
               urlRequest.httpBody = try JSONEncoder().encode(keyRequest);
               let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
                   guard let httpResponse = response as? HTTPURLResponse,
                       let jsonData = data else {
                           completion(.failure(APIRequest.INTERNAL_ERROR));
                           return;
                   }
                   do {
                        switch httpResponse.statusCode {
                        case 201:
                           let keyOrder = try JSONDecoder().decode(KeyOrder.self, from: jsonData);
                           completion(.success(keyOrder));
                        case 400:
                            completion(.failure(APIError("Bad Request")));
                        default:
                            completion(.failure(APIRequest.INTERNAL_ERROR));
                        }
                   } catch {
                       completion(.failure(APIRequest.INTERNAL_ERROR));
                   }
               }
               dataTask.resume();
           } catch {
               completion(.failure(APIRequest.INTERNAL_ERROR));
           }
       }
    
    func getKeyRequestForLabel(_ label: String,
                            completion: @escaping(Result<KeyOrder, APIError>) -> Void) {
    guard let resourceURL = URL(string: APIRequest.mainURL
        + "keyrequests/active/label/" + label) else {fatalError()};
          do {
            var urlRequest = URLRequest(url: resourceURL);
              urlRequest.httpMethod = "GET";
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type");
            urlRequest.addValue("Bearer " + TokenService().getAccessToken(), forHTTPHeaderField: "Authorization");
              let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
                  guard let httpResponse = response as? HTTPURLResponse,
                      let jsonData = data else {
                        completion(.failure(APIRequest.INTERNAL_ERROR));
                        return;
                  }
                  do {
                     switch httpResponse.statusCode {
                     case 200:
                            let keyOrder = try JSONDecoder().decode(KeyOrder.self, from: jsonData);
                            completion(.success(keyOrder));
                     case 400:
                        completion(.failure(APIError("Bad Request")));
                     default:
                        completion(.failure(APIRequest.INTERNAL_ERROR));
                    };
                  } catch {
                    completion(.failure(APIRequest.INTERNAL_ERROR));
                  }
              }
              dataTask.resume();
          }
      }
    
    func patchKeyRequest(_ label: String, values: String,
                            completion: @escaping(Result<KeyOrder, APIError>) -> Void) {
    guard let resourceURL = URL(string: APIRequest.mainURL
        + "keyrequests/active/label/" + label) else {fatalError()};
          do {
            var urlRequest = URLRequest(url: resourceURL);
              urlRequest.httpMethod = "PATCH";
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type");
            urlRequest.addValue("Bearer " + TokenService().getAccessToken(), forHTTPHeaderField: "Authorization");
            urlRequest.httpBody = try JSONEncoder().encode(values);
              let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
                  guard let httpResponse = response as? HTTPURLResponse,
                      let jsonData = data else {
                        completion(.failure(APIRequest.INTERNAL_ERROR));
                        return;
                  }
                  do {
                     switch httpResponse.statusCode {
                     case 200:
                            let keyOrder = try JSONDecoder().decode(KeyOrder.self, from: jsonData);
                            completion(.success(keyOrder));
                     case 400:
                        completion(.failure(APIError("Bad Request")));
                     default:
                        completion(.failure(APIRequest.INTERNAL_ERROR));
                    };
                  } catch {
                    completion(.failure(APIRequest.INTERNAL_ERROR));
                  }
              }
              dataTask.resume();
          } catch {
              completion(.failure(APIRequest.INTERNAL_ERROR));
          }
        
      }
}
