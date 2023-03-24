Feature: Testing for Detective graphql endpoints

  Background:
    * url baseUrl + '/graphql'
  Scenario: Test service get all detectives with id and version
    Given text query =
    """
      {
        getDetectives(count:5) {
          id
          version
        }
      }
    """
    And request {query: '#(query)'}
    When method POST
    Then status 200
    And match $.data.getDetectives[0].id == '#string'
    And match $.data.getDetectives[0].version == '#number'
    And match $.data.getDetectives[0].firstName == '#notpresent'
    And match $.data.getDetectives[0].lastName == '#notpresent'
    And match $.data.getDetectives[0].rank == '#notpresent'

  Scenario: Test service get only 2 detectives with id, version , firstName and lastName
    Given text query =
    """
      {
        getDetectives(count:2) {
          id
          version
          firstName
          lastName
        }
      }
    """
    And request {query: '#(query)'}
    When method POST
    Then status 200
    And match $.data.getDetectives[0].id == '#string'
    And match $.data.getDetectives[0].version == '#number'
    And match $.data.getDetectives[0].firstName == '#string'
    And match $.data.getDetectives[0].lastName == '#string'
    And match $.data.getDetectives[0].rank == '#notpresent'
    And match (response.data.getDetectives.length) == 2

  Scenario: Get detective by id
    Given text query =
    """
      {
        getDetectiveById(id:2) {
          id
          version
          firstName
          lastName
        }
      }
    """
    And request {query: '#(query)'}
    When method POST
    Then status 200
    And match response.data.getDetectiveById.id == "2"
    And match response.data.getDetectiveById.version == 0
    And match response.data.getDetectiveById.firstName == "Lionel"
    And match response.data.getDetectiveById.lastName == "Messi"

  Scenario: Create, Update and Delete detective
    Given text query =
    """
      mutation {
          saveDetective(firstName: "Zack", lastName: "Jac", rank: OFFICER) {
              id
              firstName
              lastName
              version
              rank
          }
      }
    """
    And request {query: '#(query)'}
    When method POST
    Then status 200
    And match response.data.saveDetective.id == '#string'
    * def detectiveId = response.data.saveDetective.id
    * def detectiveVersion = response.data.saveDetective.version
    And match response.data.saveDetective.version == 0
    And match response.data.saveDetective.firstName == "Zack"
    And match response.data.saveDetective.lastName == "Jac"
    And match response.data.saveDetective.rank == 'OFFICER'
    Given text updateQuery =
    """
      mutation {
        updateDetective(id: @@id@@, firstName: "Zap", lastName: "Jack") {
            id
            firstName
            lastName
            version
        }
      }
    """
    And replace updateQuery
      | token  | value       |
      | @@id@@ | detectiveId |
    And request {query: '#(updateQuery)'}
    When method POST
    Then status 200
    And match response.data.updateDetective.firstName == "Zap"
    And match response.data.updateDetective.lastName == "Jack"
    And match response.data.updateDetective.version == (detectiveVersion + 1)
    And match response.data.updateDetective.id == detectiveId
    Given text deleteQuery =
    """
      mutation {
        deleteDetective(id: @@id@@)
      }
    """
    And replace deleteQuery
      | token  | value       |
      | @@id@@ | detectiveId |
    And request {query: '#(deleteQuery)'}
    When method POST
    Then status 200
    Given text query =
    """
      {
        getDetectiveById(id: @@id@@) {
          id
          version
          firstName
          lastName
        }
      }
    """
    And replace query
    | token | value |
    |@@id@@ | detectiveId |
    And request {query: '#(query)'}
    When method POST
    Then status 200
    And response.errors == '#notnull'
    And response.errors[0].message == 'Detective not found'
    And response.errors[0].extensions.classification == 'NOT_FOUND'