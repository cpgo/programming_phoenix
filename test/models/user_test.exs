defmodule Rumbl.UserTest do
  use Rumbl.ModelCase, async: true
  alias Rumbl.User

  @valid_attrs %{name: "A user", username: "eva", password: "secret"}
  @invalid_attrs %{}


  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset does not accept long usernames" do
    attrs = Map.put(@valid_attrs, :username, String.duplicate("a", 30))
    assert errors_on(%User{}, attrs) == [username: "should be at most 20 character(s)"]
  end

  test "registration password must be at least 6 chars long" do
    attrs = Map.put(@valid_attrs, :password, "1234")
    changeset = User.registration_changeset(%User{}, attrs)
    assert changeset.errors == [password: {"should be at least %{count} character(s)", [count: 6]}]
  end

  test "registration_chageset with valid attributes hashes password" do
    attrs = Map.put(@valid_attrs, :password, "123456")
    changeset = User.registration_changeset(%User{}, attrs)
    %{password: pass, password_hash: pass_hash} = changeset.changes
    assert changeset.valid?
    assert pass_hash
    assert Comeonin.Bcrypt.checkpw(pass, pass_hash)
  end



end
