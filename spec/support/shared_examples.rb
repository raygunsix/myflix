shared_examples 'requires sign in' do
  it 'redirects to the sign in page' do
    session[:user_id] = nil
    action
    response.should redirect_to sign_in_path
  end
end

shared_examples "tokenable" do
  it "generates a random token upon create" do
    object.token.should be_present
  end
end