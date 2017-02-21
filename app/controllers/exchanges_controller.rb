class ExchangesController < ApplicationController
  before_action :set_exchange, only: [:show, :edit, :update, :destroy]
  before_action :check_editors, except: [:show, :index, :download_file]
  before_action :check_viewers, only: [:show, :index, :download_file]

  def download_file
    if @file = ExchangeFile.find_by('id = ?', params[:id]) # ok
      @exchange = @file.exchange
      if @exchange
        path = @file.path
        send_file Rails.root.to_s + path, x_sendfile: true if path
      else
        flash[:alert] = t(:no_file)
        redirect_to root_path
      end
    else
      flash[:alert] = t(:no_file)
      redirect_to root_path
    end
  end

  def delete_file
    if @file = ExchangeFile.find_by('id = ?', params[:id]) # ok
      @exchange = @file.exchange
      if @file.destroy
        flash[:notice] = t(:file_was_deleted)
        redirect_to edit_exchange_path(@exchange.id)
      else
        flash[:notice] = t(:file_was_not_deleted)
        redirect_to root_path
      end
    else
      flash[:alert] = t(:no_file)
      redirect_to root_path
    end
  end

  def index
    @exchanges = Exchange.all
  end

  def show
  end

  def new
    data = Net::HTTP.get('www.cbr.ru', '/scripts/XML_daily.asp') rescue nil
    hash = Hash.from_xml(data) rescue nil
    extract_data(hash)
    @usd = get_quotation('USD')
    @eur = get_quotation('EUR')
    @chf = get_quotation('CHF')

    @exchange = Exchange.new
  end

  def edit
    @exchange.date = @exchange.date + @exchange.date.localtime.utc_offset
  end

  def create
    @exchange = Exchange.new(exchange_params)
    if @exchange.save
      files = params[:exchange][:files]
      dir = "private/files/exchanges/exchange_#{@exchange.id}/"
      handle_files(@exchange, :exchange_files, files, dir) if files
      @exchange.fill_journal
      flash[:notice] = t(:exchange_was_created)
      redirect_to @exchange
    else
      render :new
    end
  end

  def update
    if @exchange.update(exchange_params)
      files = params[:exchange][:files]
      dir = "private/files/exchanges/exchange_#{@exchange.id}/"
      handle_files(@exchange, :exchange_files, files, dir) if files
      @exchange.update_journal
      flash[:notice] = t(:exchange_was_updated)
      redirect_to @exchange
    else
      render :edit
    end
  end

  def destroy
    if @exchange.destroy
      flash[:notice] = t(:exchange_was_deleted)
      redirect_to exchanges_path
    else
      flash[:notice] = t(:exchange_was_not_deleted)
      redirect_to root_path
    end
  end

  private
    def set_exchange
      @exchange = Exchange.find(params[:id])
    end

    def check_editors
      if !cfo_treasurer_case?
        flash[:error] = t(:not_allowed)
        redirect_to root_path
      end
    end

    def check_viewers
      if !can_see_as_auditor_cfo_treasurer?
        flash[:error] = t(:not_allowed)
        redirect_to root_path
      end
    end

    def exchange_params
      params.require(:exchange).permit(:date, :from_currency, :to_currency,
                                                              :amount_before,
                                                              :amount_after,
                                                              :conversion_rate,
                                                              :conversion_type,
                                                              :description,
                                                              :user_id,
                                                              :files)
    end

    def set_new_quotations(usd, eur, chf)
      Quotation.update_quotation_value('USD', usd)
      Quotation.update_quotation_value('EUR', eur)
      Quotation.update_quotation_value('CHF', chf)
    end

    def extract_data(hash)
      if hash && hash['ValCurs']
        quotations_date = hash['ValCurs']['Date']
        quotations = hash['ValCurs']['Valute']
        usd = quotations.find { |q| q['ID'] == 'R01235' }
        eur = quotations.find { |q| q['ID'] == 'R01239' }
        chf = quotations.find { |q| q['ID'] == 'R01775' }
        set_new_quotations(usd['Value'], eur['Value'], chf['Value'])
      end
    end

    def get_quotation(code)
      Quotation.find_by(code: Quotation.codes[code])
    end
end
