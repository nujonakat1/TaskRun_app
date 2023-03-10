require "rails_helper"

describe "タスク管理機能", type: :system do
    let(:user_a) { FactoryBot.create(:user, name: "ユーザーA", email: "a@example.com") }
    let(:user_b) { FactoryBot.create(:user, name: "ユーザーB", email: "b@example.com") }
    let!(:task_a) { FactoryBot.create(:task, name: "最初のタスク", user: user_a) }
    
    before do
        visit login_path
        fill_in "メールアドレス", with: login_user.email
        fill_in "パスワード", with: login_user.password
        click_button "ログインする"
    end

    shared_examples_for "ユーザーAが作成したタスク一覧が表示される" do
        it { expect(page).to have_content "最初のタスク" }
    end
    
    describe "⚫︎一覧表示機能" do
        context "ユーザーAがログインしているとき" do
            let(:login_user) { user_a }

            it_behaves_like "ユーザーAが作成したタスク一覧が表示される"
        end

        context "ユーザーBがログインしているとき" do
            let(:login_user) { user_b }

            it "ユーザーAが作成したタスク一覧が表示されない" do
                expect(page).to have_no_content "最初のタスク"  
            end
        end
    end

    describe "⚫︎詳細表示機能" do
        context "ユーザーAがログインしているとき" do
            let(:login_user) { user_a }

            before do
                visit task_path(task_a)
            end

            it_behaves_like "ユーザーAが作成したタスク一覧が表示される"
        end
    end

    describe "⚫︎新規作成機能" do
        let(:login_user) { user_a }

        before do
            visit new_task_path
            fill_in "名称", with: task_name
            click_button "登録する"
        end

        context "新規作成画面で名称を入力したとき" do
            let(:task_name) { "新規作成のテストを書く" }

            it "正常に登録される" do
                expect(page).to have_selector ".alert-success", text: "新規作成のテストを書く"  
            end
        end

        context "新規作成画面で名称を入力しなかったとき" do
            let(:task_name) { "" }

            it "エラーとなる" do
                within "#error_explanation" do
                    expect(page).to have_content "名称を入力してください"  
                end
            end
        end
    end

    describe "⚫︎タスクの更新機能" do
        let(:login_user) { user_a } 

        before do
            visit edit_task_path(task_a) 
            fill_in "名称", with: task_name
            click_button "更新する"
        end

        context "タスク編集画面で名称を入力したとき" do
            let(:task_name) { "更新のテストを書く" }

            it "正常に更新される" do
                expect(page).to have_selector ".alert-success", text: "更新のテストを書く"  
            end
        end

        context "タスク編集画面で名称を入力しなかったとき" do
            let(:task_name) { "" }

            it "エラーとなる" do
                within "#error_explanation" do
                    expect(page).to have_content "名称を入力してください"  
                end
            end
        end
    end

    describe "⚫︎タスクの削除機能" do
        let(:login_user) { user_a }
        
        before do
            visit task_path(task_a) 
            # delete task_path(task_a)
            # click_button "削除"
        end

        context "タスク削除がされたとき" do
            # delete :destroy
            before do
                delete task_path(task_a)
            end

            it "正常に削除される" do
                # expect(page).to have_selector ".alert-success", text: "タスクを削除しました"  
                # expect(task_name).not_to include("最初のタスク")
                # expect(:task).to eq nil
                # expect(:task).not_to include("最初のタスク")
                # expect(page).to have_no_content "最初のタスク"
            end
        end

        context "タスク削除ができなかったとき" do
            let(:login_user) { user_a }

            it_behaves_like "ユーザーAが作成したタスク一覧が表示される"
        end
        
    end

end