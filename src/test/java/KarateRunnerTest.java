import com.intuit.karate.junit5.Karate;

import static org.junit.jupiter.api.Assertions.assertEquals;

class KarateRunnerTest {
	@Karate.Test
	Karate testAllDetective() {
		return Karate.run("classpath:features/detective.feature");
	}
}
