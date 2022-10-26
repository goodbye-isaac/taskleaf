require 'rails_helper'

describe 'タスク管理機能', type: :system, js: true do
	let(:user_a) {FactoryBot.create(:user,name: 'ユーザーA', email: 'a@example.com')}
	let(:user_b) {FactoryBot.create(:user,name: 'ユーザーB', email: 'b@example.com')}
	let!(:task_a) {FactoryBot.create(:task, name: '最初のタスク', user: user_a)}
	before do
		visit login_path
		fill_in 'メールアドレス', with: login_user.email
		fill_in 'パスワード', with: login_user.password
		click_button 'ログインする'
	end
	#DRY部分
	shared_examples_for 'ユーザーAが作成したタスクが表示される' do
		it { expect(page).to have_content '最初のタスク' }
	end

	describe '一覧表示機能' do
		context 'ユーザーAがログインしている時' do
			let(:login_user) {user_a}

			it_behaves_like 'ユーザーAが作成したタスクが表示される'
		end

		context 'ユーザーBがログインしている時' do
			let(:login_user) {user_b}

			it 'ユーザーAが作成したタスクが表示されない' do
				expect(page).to have_no_content '最初のタスク'
			end
		end
	end

	describe '詳細表示機能' do
		context 'ユーザーAがログインしている時' do
			let(:login_user) {user_a}

			before do
				visit task_path(task_a)
			end

			it_behaves_like 'ユーザーAが作成したタスクが表示される'
		end
	end

	describe '新規作成機能' do
		let(:login_user) {user_a}

		before do
			visit new_task_path
			fill_in '名称', with: task_name
			click_button '登録する'
		end

		context '名称を入力した時' do
			let(:task_name) {'新規作成のテストを書く'}

			it '正常に登録される' do
				expect(page).to have_selector '.alert-success', text: '新規作成のテストを書く'
			end
		end

		context '名称を入力しなかった時' do
			let(:task_name) {''}

			it '登録されない' do
				expect(page).to have_selector '#error_explanation' , text: '名称を入力してください'
			end
		end
	end

	describe '更新機能' do
		let(:login_user) {user_a}
		let(:task_name) {'更新機能のテストを書く'}

		before do 
			visit new_task_path
			fill_in '名称', with: task_name
			click_button '登録する'
		end

		context 'タスクの更新をした時' do
			let(:task_name) {'タスクの更新'}
			before do
				visit edit_task_path(task_a)
				fill_in '名称', with: task_name
				click_button '更新する'
			end

			it '正常に更新される' do
				expect(page).to have_selector '.alert-success', text: 'タスク「タスクの更新を更新しました。」'
			end
		end
	end
end