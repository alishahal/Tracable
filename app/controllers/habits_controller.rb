class HabitsController < ApplicationController

    before_action :current_habit, only: [:show, :edit, :update]
    before_action :all_progress_goals_for_user, only: [:new, :edit]

    def show
        # byebug
    end

    def new
        @habit = Habit.new
    end

    def create
        @habit = Habit.create(habit_params)
        redirect_to @habit
        @new_journal = Journal.create(entry: "You created a #{@habit.name} habit", user_id: session[:user_id])
    end

    def edit
    end

    def update
        if !@habit.complete
            @habit.update(habit_params)
            redirect_to @habit
            @new_journal = Journal.create(entry: "You updated a #{@habit.name} habit", user_id: session[:user_id])
        else
            flash[:custom] = ("You cannot edit a completed habit")
            redirect_to edit_habit_path
        end 
    end

    def complete_habit
        @habit = Habit.find(params[:habit_id])
        @habit.completed_it
        @habit.save
        @habit.completing_goal
        @habit.save
        @goal = Goal.find(@habit.goal.id)
        @goal.complete = @habit.goal.complete
        @goal.save
        redirect_to user_path
        @new_journal = Journal.create(entry: "You completed #{@habit.name} habit", user_id: session[:user_id])
    end

    def current_habit
        @habit = Habit.find(params[:id])
    end

    def all_progress_goals_for_user
        @g = Goal.where(user_id: session[:user_id])
        @goals = @g.select { |g| g.complete == false}
    end

    private

    def habit_params
        params.require(:habit).permit(:name, :description, :goal_id, :complete)
    end

end
