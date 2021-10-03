load_lib() {
  local name="$1"
  load "test_helper/${name}/load"
}

load_lib bats-support
load_lib bats-assert
load_lib bats-file

teardown() {
    echo "teardown"
    rm -rf out/*
}

# @test "can run our script" {
#     .shub/bin/colors.sh
# }

# @test 'assert_equal()' {
#   assert_equal 'have' 'have'
# }

@test 'template files are downloaded' {
  ENV="test" ./.shub/bin/get.sh downloadTemplates
  assert_file_exist test/out/README.md
}


