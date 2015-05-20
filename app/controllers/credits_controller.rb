class CreditsController < ApplicationController
  before_action :set_credit, only: [:show, :edit, :update, :destroy]
  include CreditsHelper
  include ActionView::Helpers::NumberHelper
  
  def checkout
    @credit_holder = CreditHolder.find(params[:credit_holder_id])
  end

  def process_transaction
    @total = params[:total].to_f
    id = params[:credit_holder_id]
    @credits = credits_from_id(params[:credit_holder_id])
    @oldest = get_oldest(@credits)
    puts '********************************************'
    @paymentamount = cashier(id, @total)
    puts '********************************************'
    update_credits_total(params[:credit_holder_id])

  end 

  def add_credit(credit_holder, credit)
    new_total = credit.amount + credit_holder.credits_total
    CreditHolder.update(credit_holder.id, :credits_total => new_total)
  end

  # GET /credits
  # GET /credits.json
  def index
    @credits = Credit.all
  end

  # GET /credits/1
  # GET /credits/1.json
  def show
  end

  # GET /credits/new
  def new
    @credit = Credit.new
    @credit_holder_id = params[:credit_holder_id]
    @credit_holder = CreditHolder.find(@credit_holder_id)
  end

  # GET /credits/1/edit
  def edit
  end

  # POST /credits
  # POST /credits.json
  def create
    @credit = Credit.new(credit_params)

    respond_to do |format|
      if @credit.save
        notice = 'Credit was successfully created.'
        creditholder = CreditHolder.find(@credit.credit_holder_id)
        if  @credit[:send_email] == 1 && creditholder.email_address.present?
          CreditNotifier.created(creditholder,@credit).deliver
          notice = 'Credit was successfully created and Email notification was sent.'
        elsif @credit[:send_email] == 0
          notice = 'Credit was successfully created.'
        else 
          notice = 'Credit was successfully created but Email notification was NOT sent, check to see if we have a valid email for that customer.'
        end
        add_credit(creditholder, @credit)
        format.html { redirect_to root_path, notice: notice }
        format.json { render :show, status: :created, location: @credit }
      else
        format.html { render :new }
        format.json { render json: @credit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /credits/1
  # PATCH/PUT /credits/1.json
  def update
    respond_to do |format|
      if @credit.update(credit_params)
        format.html { redirect_to @credit, notice: 'Credit was successfully updated.' }
        format.json { render :show, status: :ok, location: @credit }
      else
        format.html { render :edit }
        format.json { render json: @credit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /credits/1
  # DELETE /credits/1.json
  def destroy
    @credit.destroy
    respond_to do |format|
      format.html { redirect_to credits_url, notice: 'Credit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_credit
      @credit = Credit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def credit_params
      params.require(:credit).permit(:amount, :expires_at, :status, :credit_holder_id, :send_email)
    end
end
