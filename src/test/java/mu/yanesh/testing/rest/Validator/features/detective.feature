Feature: Testing for Detective's endpoint
  Scenario: Test service get all detectives
  Given url 'http://localhost:8080/api/rest/detectives'
  When method GET
  Then status 200