package ig

import io.gatling.core.Predef._
import io.gatling.core.scenario.Simulation
import io.gatling.core.structure.ScenarioBuilder
import io.gatling.http.Predef._
import io.gatling.http.protocol.HttpProtocolBuilder

class IGAccessTokensNoCacheSim extends Simulation {

  val concurrency: Integer = Integer.getInteger("concurrency", 10)
  val duration: Integer = Integer.getInteger("duration", 600)
  val warmup: Integer = Integer.getInteger("warmup", 1)
  val igHost: String = System.getProperty("ig_host", "openig.prod.perf.forgerock-qa.com")
  val igPort: String = System.getProperty("ig_port", "443")
  val igProtocol: String = System.getProperty("ig_protocol", "https")
  val igContext: String = System.getProperty("ig_context", "")
    
  val igUrl: String = igProtocol + "://" + igHost + ":" + igPort + igContext
  val random = new util.Random

  val csvFile: String = System.getProperty("csv_file_path", "/tmp/tokens.csv")
  
  val httpProtocol: HttpProtocolBuilder = http
    .baseURLs(igUrl)
    .inferHtmlResources()
    .header("Accept-API-Version", "resource=2.0, protocol=1.0")
    
  val accessTokenScenario: ScenarioBuilder = scenario("IG Token Info flow")
    .during(duration) {
      feed(csv(csvFile).random)
        .exec(
          http("tokeninfo")
            .post("/rs-tokeninfo-nocache")
            .header("Authorization", "Bearer ${tokens}")
            .check(status.is(200))
        )
    }
    
  setUp(accessTokenScenario.inject(rampUsers(concurrency) over warmup)).protocols(httpProtocol)
}