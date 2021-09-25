# frozen_string_literal: true

module Members
  class SessionsController < Devise::SessionsController
    before_action :reject_member, only: [:create]
    # before_action :configure_sign_in_params, only: [:create]

    # GET /resource/sign_in
    # def new
    #   super
    # end

    # POST /resource/sign_in
    # def create
    #   super
    # end

    # DELETE /resource/sign_out
    # def destroy
    #   super
    # end

    protected

    def reject_member
      # 入力されたemailを小文字に変換し、カラムに保存されたmemberのemailと一致した場合@memberに代入
      @member = Member.find_by(email: params[:member][:email].downcase)
      if @member
        # @memberのemailに紐づいているpasswardが正しいか　&&  modelで定義したis_deletedがtrueではないか
        if @member.valid_password?(params[:member][:password]) && (@member.active_for_authentication? == false)
          flash[:error] = '退会済みです。。'
          redirect_to new_member_session_path
        end
      else
        flash[:error] = '必須項目を入力してください!'
      end
    end

    # sign_in後の変移先
    def after_sign_in_path_for(resource)
      member_path(current_member)
    end
    
    # サインアウト後の遷移先を修正する
    def after_sign_out_path_for(resource)
      member_session_path
    end
    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    # end
  end
end
