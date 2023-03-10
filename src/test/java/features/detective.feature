Feature: Testing for Detective's endpoint
  Background:
    * url baseUrl + '/api/rest'
    * def expectedDetective =
    """
      {
      "id": 3,
      "version": 1,
      "firstName": "Crist",
      "lastName": "Ron",
      "rank": "LIEUTENANT"
      }
    """
  Scenario: Test service get all detectives
    * def uri = '/detectives'

    * def fakeDetective =
    """
      {
      "id": 999,
      "version": 0,
      "firstName": "Charlie",
      "lastName": "Banana",
      "rank": "OFFICER"
      }
    """
  Given path uri
  When method GET
  Then status 200
  And match response contains expectedDetective
  And match response !contains fakeDetective

  Scenario: Get detective by id
    * def uri = '/detective'
  Given path uri, 3
  When method GET
  Then status 200
  And match response contains expectedDetective

  Scenario: Create, Update and Delete detective
    * def uri = '/detective'
    * def requestBody =
    """
    {
    "firstName": "John",
    "lastName": "David",
    "rank": "SERGEANT"
    }
    """
  Given path uri
  And request requestBody
  When method POST
  Then status 200
  And match response contains requestBody
  And match response contains {id: '#notnull', version: '#notnull'}
  And match response.id == '#number'
  And match response.version == '#number'
  * def newDetectiveId = response.id
  * def newDetectiveVersion = response.version + 1
  Given path uri
  And request {id: #(response.id), version: #(response.version), firstName: "Jack", lastName:"Pelerta", rank: "SERGEANT"}
  When method PUT
  Then status 200
  And match response contains {id: #(newDetectiveId), version: #(newDetectiveVersion)}
  And match response.firstName == "Jack"
  And match response.lastName == "Pelerta"
  Given path uri, response.id
  When method DELETE
  Then status 200
  And match response == 'true'