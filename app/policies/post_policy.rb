class PostPolicy < ApplicationPolicy
  def show
    true
  end

  def new?
    user
  end

  def create?
    user
  end

  def edit?
    user and user == record.user
  end

  def update?
    user and user == record.user
  end

  def destroy?
    user and user == record.user
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
