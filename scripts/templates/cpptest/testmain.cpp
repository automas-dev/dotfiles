#include "test.h"

int test_hello_world() {
	ASSERT_TRUE(1);
	return 0;
}

int main() {
	TEST(test_hello_world);
	return 0;
}

