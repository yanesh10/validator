package mu.yanesh.testing.rest.Validator;

import com.intuit.karate.junit5.Karate;

class KarateRunner {
	@Karate.Test
	Karate testAll() {
		return Karate.run().relativeTo(getClass());
	}
}
