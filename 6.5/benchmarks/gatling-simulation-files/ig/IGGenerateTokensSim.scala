package ig

import io.gatling.core.Predef._
import io.gatling.core.scenario.Simulation
import io.gatling.core.structure.ScenarioBuilder
import io.gatling.http.Predef._
import io.gatling.http.protocol.HttpProtocolBuilder
import java.io.File
import java.io.PrintWriter
import java.io.FileOutputStream

class IGGenerateTokens extends Simulation {

  val userPoolSize: Integer = Integer.getInteger("users", 1000)
  val concurrency: Integer = Integer.getInteger("concurrency", 25)
  val duration: Integer = Integer.getInteger("duration", 30)
  val warmup: Integer = Integer.getInteger("warmup", 1)
  val amHost: String = System.getProperty("am_host", "login.prod.perf.forgerock-qa.com")
  val amPort: String = System.getProperty("am_port", "443")
  val amProtocol: String = System.getProperty("am_protocol", "https")
  
  val oauth2ClientId: String = System.getProperty("oauth2_client_id", "client-application")
  val oauth2ClientPassword: String = System.getProperty("oauth2_client_pw", "password")
  
  val realm: String = System.getProperty("realm", "/")
  val scope: String = System.getProperty("scope", "mail employeenumber")
  val tokenVarName = "token"
  var accessTokenVarName = "access_token"
  
  val amUrl: String = amProtocol + "://" + amHost + ":" + amPort
  val random = new util.Random
  
  val header = "tokens"
  val csvFile = "tokens.csv"
  
  val userFeeder: Iterator[Map[String, String]] = Iterator.continually(Map(
    """username""" -> ("""user.""" + random.nextInt(userPoolSize).toString),
    """password""" -> "password")
  )
  
  def getXOpenAMHeaders(username: String, password: String): scala.collection.immutable.Map[String, String] = {
    scala.collection.immutable.Map(
      "X-OpenAM-Username" -> username,
      "X-OpenAM-Password" -> password)
  }
  
  def createCSVFile() = {
    val s1 = new File(csvFile)
    if (s1.exists) {
      s1.delete()
    }
    val writer = new PrintWriter(new FileOutputStream(new File(csvFile)))
    writer.println(header)
    writer.close()
  }
  
  val httpProtocol: HttpProtocolBuilder = http
    .baseURLs(amUrl)
    .inferHtmlResources()
    .header("Accept-API-Version", "resource=2.0, protocol=1.0")
    
  val generateTokenScenario: ScenarioBuilder = scenario("OAuth2 Auth code flow")
    .during(duration) {
      createCSVFile()
      feed(userFeeder)
        .exec(
          http("Request Token stage")
            .post("/oauth2/access_token")
            .queryParam("realm", realm)
            .formParam("grant_type", "password")
            .formParam("scope", scope)
            .formParam("username", "${username}")
            .formParam("password", "${password}")
            .basicAuth(oauth2ClientId, oauth2ClientPassword)
            .check(jsonPath("$.access_token").find.saveAs(accessTokenVarName))
        ).exec (
        session => {
          val writer = new PrintWriter(new FileOutputStream(new File(csvFile), true))
          writer.write(session(accessTokenVarName).as[String])
          writer.write("\n")
          writer.close()
          session
        }
      )
    }

  setUp(generateTokenScenario.inject(rampUsers(concurrency) over warmup)).protocols(httpProtocol)
}

