# frozen_string_literal: true

require 'rails_helper'

describe '投稿のテスト' do
  let!(:list) { create(:list,title:'hoge',body:'body') }
  describe 'トップ画面(top_path)のテスト' do
    before do
      visit top_path
    end
    context '表示の確認' do
      it 'トップ画面(top_path)に「ここはTopページです」が表示されているか' do
        expect(page).to have_content 'ここはTopページです'
      end
      it 'top_pathが"/top"であるか' do
        # 現在のページURLを期待値として、epで指定した値と同値であるか
        expect(current_path).to eq('/top')      
      end
    end  
  end    
  
  describe '投稿画面(lists_new_path)のテスト投稿画面のテスト' do
    before do
      visit lists_new_path
    end
    context '表示の確認'
      it 'todolists_new_pathが"/todolists/new"であるか' do
        # 現在のページURLを期待値として、epで指定した値と同値であるか
        expect(current_path).to eq('/todolists/new')      
      end
      it '投稿ボタンが表示されているか' do
        expect(page).to have_button "投稿"
      end  
    context '投稿処理のテスト'
      it '投稿後のリダイレクト先は正しいか' do
        fill_in 'list[title]', with: Faker::Lorem.characters(number:5)
        fill_in 'list[body]', with: Faker::Lorem.characters(number:20)
        click_button '投稿'
        # 現在のURLパスを取得し、投稿後のページURLが正しいURLパスであるかを判定
        expect(page).to have_current_path list_path(List.last)
      end  
  end
  
  describe '一覧画面のテスト' do
    before do
      visit lists_path
    end
    context '一覧の表示とリンクの確認' do
      it '一覧表示画面に投稿されたもの表示されているか' do
        expect(page).to have_content list.title
        expect(page).to have_link list.title
      end
	  end
	end
	
	
	describe '詳細画面のテスト' do
	  before do
	    visit list_path(list)
	  end
	  context '表示のテスト' do
	    it '削除リンクが存在しているか' do
        expect(page).to have_link "削除"
	    end
	    it '編集リンクが存在しているか' do
        expect(page).to have_link "編集"
      end
    end  
    context 'リンクの遷移先の確認' do
      it '編集の遷移先は編集画面か' do
        # ３番目のaリンクを代入
        edit_link = find_all('a')[3]
        # エディット画面へ遷移
        edit_link.click
        # 現在のURLがepで指定したリンクと同値か判定
        expect(current_path).to eq('/todolists/' + list.id.to_s + '/edit')
      end  
    end
    context 'list削除のテスト' do
      it 'listの削除' do
        expect{ list.destroy }.to change{ List.count }.by(-1)
      end
    end
  end
  
  describe '編集画面のテスト' do
    before do
      visit edit_list_path(list)
    end
    context '表示の確認' do
      it '編集前のタイトルと本文がフォームに表示(セット)されている' do
        expect(page).to have_field 'list[title]', with: list.title
        expect(page).to have_field 'list[body]', with: list.body
      end
      it '保存ボタンが表示される' do
        expect(page).to have_button '保存'
      end
    end
    context '更新処理に関するテスト' do
      it '更新後のリダイレクト先は正しいか' do
        fill_in 'list[title]', with: Faker::Lorem.characters(number:5)
        fill_in 'list[body]', with: Faker::Lorem.characters(number:20)
        click_button '保存'
        expect(page).to have_current_path list_path(list)
      end
    end
  end
end       
