class PackagesController < ApplicationController
  include Pagy::Backend

  #before_action :package_params, only: [:new]

  def show
    logger.info "Detail PARAMS ==>#{params[:cancel]}"

    # if the Merchant order code is not empty send cancel request
    if params.has_key?(:cancel)
      logger.info " CANECEL ==> #{current_user.uid}"
      cancelPackage = HTTParty.post("http://localhost:3030/api/packages/",
                                    {
        :headers => {
          "Content-Type" => "application/json",
          "user_id" => "#{current_user.uid}",
          "merchant_order_id" => "#{params[:cancel]}",
        },
      })

      # after cancel redirect back to create page
      if cancelPackage
        redirect_to create_package_path
      end
    end
  end

  def new
    logger.info "PARAMS #{params[:package]}"
    return redirect_to signin_path(:package => params[:package]),
                       flash: { info: I18n.t("login_required") } unless current_user
    logger.info "Current User in package ==>showing ...}"
    if current_user
      return redirect_to create_package_path packages: params[:package]
    end
  end

  def create
    # TODO:: Implement allPayments for the Table Show Method
    allPayments = HTTParty.get("http://localhost:3030/api/packages/",
                               :headers => {
                                 "Content-Type" => "application/json",
                                 "user_id" => "#{current_user.uid}",
                               })
    
    @pagy, @packages = pagy_array(allPayments.to_a, page: 1, items: 5)
  end

  # This is actually the payment package change def name to payment_New
  def pay
    newPaymentExists = HTTParty.get("http://localhost:3030/api/packages/#{current_user.uid}",
                                    :headers => {
                                      "Content-Type" => "application/json",
                                    })
    newPaymentExists = JSON.parse(newPaymentExists.body)
    logger.info "DELETEWEST==> #{newPaymentExists == false}"

    if newPaymentExists == false
      redirect_link
    else
      flash[:alert] = I18n.t("package.flash_new")
    end
  end

  def set_bill_cycle
    redirect_to create_package_path packages: params[:package], cycle: params[:value]
    logger.info "BILLLL ...==> #{params}"
    # package_params[:cycle] = params[:value]
    #helpers.set_bill_cycle(cycle)

    #redirect_to  create_package_path
  end

  # Determines the Payment Redirect Link
  def redirect_link
    if params.has_key?(:package)
      logger.info "HAS Package Selected!!"
    else
      # A package MUST be selected to route to Selamta Pay
      flash[:alert] = I18n.t("package.select_package")
      return redirect_to create_package_path
    end

    if params.has_key?(:cycle)
      logger.info "HAS CYCLE #{params.has_key?(:cycle)}"
      redirect_to "http://localhost:3030/index?package=#{params[:package]}&cycle=#{params[:cycle]}&uid=#{params[:uid]}"
    else
      logger.info "NO CYCLE #{params.has_key?(:cycle)}"
      redirect_to "http://localhost:3030/index?package=#{params[:package]}&cycle=1&uid=#{params[:uid]}"
    end
  end

  private

  def package_params
    # @package = Package.find_by(uid: current_user.uid)
    #params.require(:package).permit(:item_id, :cycle)
  end
end
