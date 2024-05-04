#shellcheck shell=sh

% FIXTURE_DIR: "$SHELLSPEC_HELPERDIR/fixture"

# Hopefully this will be an absolute path that makes it hard to mess up the
# system even if we have a nasty bug.
% ORG_DIR: "${TMPDIR:-${TMP:-/tmp}}/test_hoist_end_to_end.$$"

# Make sure the test environment is sane before we start.
Describe 'end-to-end environment'
  It 'should have an absolute base directory'
    The variable ORG_DIR should start with "/"
  End
End

Describe 'end-to-end'
  Include './hoist'

  with_working_directory() (
    CDPATH='' cd -- "$1" || return
    shift
    "$@"
  )

  test_data_up() {
    mkdir -p "$(dirname -- "$ORG_DIR")"
    cp -r -- "$FIXTURE_DIR" "$ORG_DIR"
    find "$ORG_DIR" -name ".gitignore" -delete
  }

  test_data_down() {
    rm -r -- "$ORG_DIR"
  }

  org_chart() (
    with_working_directory "$ORG_DIR" find . \
      | LC_COLLATE=C sort
  )

  Before test_data_up
  After test_data_down

  It 'should no-op on empty explicit positional arguments'
    When call hoist --
    The output should be blank
    The error should be blank
    The status should be success
    The value "$(org_chart)" should equal "$(
      %text
      #|.
      #|./alice
      #|./customer service
      #|./customer service/--huh*?
      #|./customer service/bob
      #|./ethics
      #|./research
      #|./research/.spy
      #|./research/carol
      #|./research/engineering
      #|./research/engineering/dave
      #|./research/engineering/emily
    )"
  End

  It 'should hoist file'
    When call hoist "$ORG_DIR/research/engineering/dave"
    The output should be blank
    The error should be blank
    The status should be success
    The value "$(org_chart)" should equal "$(
      %text
      #|.
      #|./alice
      #|./customer service
      #|./customer service/--huh*?
      #|./customer service/bob
      #|./ethics
      #|./research
      #|./research/.spy
      #|./research/carol
      #|./research/dave
      #|./research/engineering
      #|./research/engineering/emily
    )"
  End

  It 'should hoist directory'
    When call hoist "$ORG_DIR/research/engineering/"
    The output should be blank
    The error should be blank
    The status should be success
    The value "$(org_chart)" should equal "$(
      %text
      #|.
      #|./alice
      #|./customer service
      #|./customer service/--huh*?
      #|./customer service/bob
      #|./ethics
      #|./research
      #|./research/.spy
      #|./research/carol
      #|./research/dave
      #|./research/emily
    )"
  End

  It 'should hoist a relative file'
    When call with_working_directory "$ORG_DIR/research/engineering/" hoist dave
    The output should be blank
    The error should be blank
    The status should be success
    The value "$(org_chart)" should equal "$(
      %text
      #|.
      #|./alice
      #|./customer service
      #|./customer service/--huh*?
      #|./customer service/bob
      #|./ethics
      #|./research
      #|./research/.spy
      #|./research/carol
      #|./research/dave
      #|./research/engineering
      #|./research/engineering/emily
    )"
  End

  It 'should hoist a relative directory'
    When call with_working_directory "$ORG_DIR/research/" hoist engineering/
    The output should be blank
    The error should be blank
    The status should be success
    The value "$(org_chart)" should equal "$(
      %text
      #|.
      #|./alice
      #|./customer service
      #|./customer service/--huh*?
      #|./customer service/bob
      #|./ethics
      #|./research
      #|./research/.spy
      #|./research/carol
      #|./research/dave
      #|./research/emily
    )"
  End

  It 'should hoist hidden files'
    When call hoist "$ORG_DIR/research/"
    The output should be blank
    The error should be blank
    The status should be success
    The value "$(org_chart)" should equal "$(
      %text
      #|.
      #|./.spy
      #|./alice
      #|./carol
      #|./customer service
      #|./customer service/--huh*?
      #|./customer service/bob
      #|./engineering
      #|./engineering/dave
      #|./engineering/emily
      #|./ethics
    )"
  End

  It 'should hoist directory with unusual names'
    When call hoist "$ORG_DIR/customer service/"
    The output should be blank
    The error should be blank
    The status should be success
    The value "$(org_chart)" should equal "$(
      %text
      #|.
      #|./--huh*?
      #|./alice
      #|./bob
      #|./ethics
      #|./research
      #|./research/.spy
      #|./research/carol
      #|./research/engineering
      #|./research/engineering/dave
      #|./research/engineering/emily
    )"
  End

  It 'should hoist empty directory'
    When call hoist "$ORG_DIR/ethics/"
    The output should be blank
    The error should be blank
    The status should be success
    The value "$(org_chart)" should equal "$(
      %text
      #|.
      #|./alice
      #|./customer service
      #|./customer service/--huh*?
      #|./customer service/bob
      #|./research
      #|./research/.spy
      #|./research/carol
      #|./research/engineering
      #|./research/engineering/dave
      #|./research/engineering/emily
    )"
  End

  It 'should hoist multiple levels'
    When call hoist --count 2 "$ORG_DIR/research/engineering/"
    The output should be blank
    The error should be blank
    The status should be success
    The value "$(org_chart)" should equal "$(
      %text
      #|.
      #|./alice
      #|./customer service
      #|./customer service/--huh*?
      #|./customer service/bob
      #|./dave
      #|./emily
      #|./ethics
      #|./research
      #|./research/.spy
      #|./research/carol
    )"
  End

  It 'should hoist multiple files'
    When call hoist "$ORG_DIR/research/engineering/dave" "$ORG_DIR/research/engineering/emily"
    The output should be blank
    The error should be blank
    The status should be success
    The value "$(org_chart)" should equal "$(
      %text
      #|.
      #|./alice
      #|./customer service
      #|./customer service/--huh*?
      #|./customer service/bob
      #|./ethics
      #|./research
      #|./research/.spy
      #|./research/carol
      #|./research/dave
      #|./research/emily
      #|./research/engineering
    )"
  End

  It 'should hoist from left to right'
    When call hoist "$ORG_DIR/research/engineering/dave" "$ORG_DIR/research/engineering"
    The output should be blank
    The error should be blank
    The status should be success
    The value "$(org_chart)" should equal "$(
      %text
      #|.
      #|./alice
      #|./customer service
      #|./customer service/--huh*?
      #|./customer service/bob
      #|./ethics
      #|./research
      #|./research/.spy
      #|./research/carol
      #|./research/dave
      #|./research/emily
    )"
  End

  It 'should fail when trying to hoist from within already-hoisted directory'
    When call hoist "$ORG_DIR/research/engineering" "$ORG_DIR/research/engineering/dave"
    The error should include 'no such file or directory'
    The status should be failure
  End

  # TODO: Test interactive mv.
  # TODO: Should this try to detect/fail in a particular way when trying to hoist the current working directory or a parent of it?

End
