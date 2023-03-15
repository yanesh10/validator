import com.intuit.karate.Results;
import com.intuit.karate.junit5.Karate;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class KarateParallelRunnerTest {
    @Karate.Test
    void testInParallel() {
		Results results = Karate.run("classpath:features/detective.feature")
                .tags("")
				.parallel(3);
		assertEquals(0, results.getFailCount());
    }
}
