Feature: Testing for Detective's endpoint
  Background:
    * url baseUrl
  Scenario: Test service get all detectives
    * def uri = '/api/rest/detectives'
  Given path uri
  When method GET
  Then status 200

  Scenario: