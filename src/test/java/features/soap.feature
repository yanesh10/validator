Feature: Test the detective soap endpoint

  Background:
    * url baseUrl + '/ws'

  Scenario: Test soap request to get detective
    When def get_request = read('/requests/get_request_detective.xml')
    And replace get_request
      | token  | value |
      | @@id@@ | 1     |
    When request get_request
    And soap action 'GetDetective'
    Then status 200
    And match /Envelope/Body/detectiveServiceResponse/detective/id == '1'
    And match / == read('responses/get_response_detective.xml')

  Scenario: Test soap request to save and delete detective
    When request read('/requests/save_request_detective.xml')
    And soap action 'SaveDetective'
    Then status 200
    And match /Envelope/Body/detectiveServiceResponse/detective/id == '#string'
    And def detectiveId = /Envelope/Body/detectiveServiceResponse/detective/id
    And match /Envelope/Body/detectiveServiceResponse/detective/version == '0'
    And match /Envelope/Body/detectiveServiceResponse/detective/firstName == 'Mickey'
    And match /Envelope/Body/detectiveServiceResponse/detective/lastName == 'Mouse'
    And match /Envelope/Body/detectiveServiceResponse/detective/rank == 'OFFICER'
    And def delete_request = read('requests/delete_request_detective.xml')
    And replace delete_request
      | token           | value       |
      | @@detectiveId@@ | detectiveId |
    When request delete_request
    And soap action 'DeleteDetective'
    Then status 202
    When def get_request = read('/requests/get_request_detective.xml')
    And replace get_request
      | token  | value |
      | @@id@@ | detectiveId     |
    And request get_request
    And soap action 'GetDetective'
    Then status 404
    And match /Envelope/Body/Fault == '#notnull'
    And match /Envelope/Body/Fault/faultstring contains 'DetectiveNotFoundException'
