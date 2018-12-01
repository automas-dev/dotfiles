#include "name.h"
#include "gtest/gtest.h"

namespace {
	TEST(PracticeTest, Test1) {
		foo();
		EXPECT_EQ(10 / 2, 5);
		EXPECT_GT(10 / 2, 0);
	}
}

int main(int argc, char **argv) {
  ::testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
