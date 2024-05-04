#shellcheck shell=sh

% ORG_DIR: "$SHELLSPEC_HELPERDIR/fixture"

Describe 'frontend'
  Include './hoist'

  It 'should fail with usage information if no arguments given'
    When call hoist
    The error should include 'Usage:'
    The status should be failure
    The status should equal 64 # EX_USAGE
  End

  It 'should fail with unknown options'
    When call hoist --unknown-option
    The error should include 'unknown option: --unknown-option'
    The status should be failure
    The status should equal 64 # EX_USAGE
  End

  Describe '--help'
    It 'should print help information'
      When call hoist -h
      The output should include 'Options:'
      The status should be success
    End

    It 'should print help information'
      When call hoist --help
      The output should include 'Options:'
      The status should be success
    End
  End

  Describe '--version'
    It 'should print version information'
      When call hoist --version
      The output should start with "hoist ${HOIST_VERSION}"
      The status should be success
    End
  End

  Describe 'positional arguments'
    It 'should not do anything on empty explicit positional arguments'
      When call hoist --dry-run --
      The error should be defined # ignore
      The status should be success
    End

    It 'should accept explicit positional arguments'
      When call hoist --dry-run -- "$ORG_DIR/research/"
      The error should be defined # ignore
      The status should be success
    End

    It 'should accept implicit positional arguments'
      When call hoist --dry-run "$ORG_DIR/research/"
      The error should be defined # ignore
      The status should be success
    End

    It 'should accept multiple positional arguments'
      When call hoist --dry-run "$ORG_DIR/customer service" -- "$ORG_DIR/ethics"
      The error should be defined # ignore
      The status should be success
    End

    It 'should accept unusual filenames in explicit positional arguments'
      When call hoist --dry-run -- "$ORG_DIR/customer service/--huh*?"
      The error should be defined # ignore
      The status should be success
    End
  End

  Describe '--count'
    It 'should accept long option'
      When call hoist --dry-run --count 17 "$ORG_DIR/research/"
      The error should be defined # ignore
      The status should be success
    End

    It 'should accept zero count'
      When call hoist --dry-run --count 0 "$ORG_DIR/research/"
      The error should be defined # ignore
      The status should be success
    End

    It 'should not accept negative count'
      When call hoist --dry-run --count -1 "$ORG_DIR/research/"
      The error should include 'invalid count'
      The status should be failure
      The status should equal 64 # EX_USAGE
    End

    It 'should accept short option'
      When call hoist --dry-run -n 1 "$ORG_DIR/research/"
      The error should be defined # ignore
      The status should be success
    End

    It 'should accept short option shorthand'
      When call hoist --dry-run -n13 "$ORG_DIR/research/"
      The error should be defined # ignore
      The status should be success
    End
  End
End
