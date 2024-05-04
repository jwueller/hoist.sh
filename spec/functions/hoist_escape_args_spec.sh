#shellcheck shell=sh

Describe 'hoist_escape_args'
  Include './hoist'

  It 'should preserve empty strings'
    When call hoist_escape_args ''
    The output should equal "''"
  End

  It 'should prevent word-splitting'
    When call hoist_escape_args 'a b'
    The output should equal "'a b'"
  End

  It 'should prevent globbing'
    When call hoist_escape_args '*'
    The output should equal "'*'"
  End

  It 'should prevent interpolation'
    # This warning is the entire point of the test, so we can ignore it.
    # shellcheck disable=SC2016
    When call hoist_escape_args '$(echo hi)'
    The output should equal "'\$(echo hi)'"
  End

  It 'should prevent command substitution'
    # This warning is the entire point of the test, so we can ignore it.
    # shellcheck disable=SC2016
    When call hoist_escape_args '`echo hi`'
    The output should equal "'\`echo hi\`'"
  End

  It 'should prevent variable expansion'
    # This warning is the entire point of the test, so we can ignore it.
    # shellcheck disable=SC2016
    When call hoist_escape_args '$HOME'
    The output should equal "'\$HOME'"
  End

  It 'should preserve double quotes'
    When call hoist_escape_args '"a"'
    The output should equal "'\"a\"'"
  End

  It 'should escape single quotes'
    When call hoist_escape_args "a'b"
    The output should equal "'a'\\''b'"
  End

  It 'should escape backslashes'
    When call hoist_escape_args 'a\\b'
    # Note: This just looks different weird because it's in double quotes, but
    # it's the same string!
    The output should equal "'a\\\\b'"
  End

  It 'should accept zero arguments'
    When call hoist_escape_args
    The output should be blank
  End

  It 'should accept multiple arguments'
    When call hoist_escape_args '*' '*'
    The output should equal "'*' '*'"
  End
End
