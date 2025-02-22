defmodule Stripe.SetupIntent do
  use Stripe.Entity

  @moduledoc "A SetupIntent guides you through the process of setting up and saving a customer's payment credentials for future payments.\nFor example, you could use a SetupIntent to set up and save your customer's card without immediately collecting a payment.\nLater, you can use [PaymentIntents](https://stripe.com/docs/api#payment_intents) to drive the payment flow.\n\nCreate a SetupIntent as soon as you're ready to collect your customer's payment credentials.\nDo not maintain long-lived, unconfirmed SetupIntents as they may no longer be valid.\nThe SetupIntent then transitions through multiple [statuses](https://stripe.com/docs/payments/intents#intent-statuses) as it guides\nyou through the setup process.\n\nSuccessful SetupIntents result in payment credentials that are optimized for future payments.\nFor example, cardholders in [certain regions](/guides/strong-customer-authentication) may need to be run through\n[Strong Customer Authentication](https://stripe.com/docs/strong-customer-authentication) at the time of payment method collection\nin order to streamline later [off-session payments](https://stripe.com/docs/payments/setup-intents).\nIf the SetupIntent is used with a [Customer](https://stripe.com/docs/api#setup_intent_object-customer), upon success,\nit will automatically attach the resulting payment method to that Customer.\nWe recommend using SetupIntents or [setup_future_usage](https://stripe.com/docs/api#payment_intent_object-setup_future_usage) on\nPaymentIntents to save payment methods in order to prevent saving invalid or unoptimized payment methods.\n\nBy using SetupIntents, you ensure that your customers experience the minimum set of required friction,\neven as regulations change over time.\n\nRelated guide: [Setup Intents API](https://stripe.com/docs/payments/setup-intents)"
  (
    defstruct [
      :application,
      :attach_to_self,
      :automatic_payment_methods,
      :cancellation_reason,
      :client_secret,
      :created,
      :customer,
      :description,
      :flow_directions,
      :id,
      :last_setup_error,
      :latest_attempt,
      :livemode,
      :mandate,
      :metadata,
      :next_action,
      :object,
      :on_behalf_of,
      :payment_method,
      :payment_method_options,
      :payment_method_types,
      :single_use_mandate,
      :status,
      :usage
    ]

    @typedoc "The `setup_intent` type.\n\n  * `application` ID of the Connect application that created the SetupIntent.\n  * `attach_to_self` If present, the SetupIntent's payment method will be attached to the in-context Stripe Account.\n\nIt can only be used for this Stripe Account’s own money movement flows like InboundTransfer and OutboundTransfers. It cannot be set to true when setting up a PaymentMethod for a Customer, and defaults to false when attaching a PaymentMethod to a Customer.\n  * `automatic_payment_methods` Settings for dynamic payment methods compatible with this Setup Intent\n  * `cancellation_reason` Reason for cancellation of this SetupIntent, one of `abandoned`, `requested_by_customer`, or `duplicate`.\n  * `client_secret` The client secret of this SetupIntent. Used for client-side retrieval using a publishable key.\n\nThe client secret can be used to complete payment setup from your frontend. It should not be stored, logged, or exposed to anyone other than the customer. Make sure that you have TLS enabled on any page that includes the client secret.\n  * `created` Time at which the object was created. Measured in seconds since the Unix epoch.\n  * `customer` ID of the Customer this SetupIntent belongs to, if one exists.\n\nIf present, the SetupIntent's payment method will be attached to the Customer on successful setup. Payment methods attached to other Customers cannot be used with this SetupIntent.\n  * `description` An arbitrary string attached to the object. Often useful for displaying to users.\n  * `flow_directions` Indicates the directions of money movement for which this payment method is intended to be used.\n\nInclude `inbound` if you intend to use the payment method as the origin to pull funds from. Include `outbound` if you intend to use the payment method as the destination to send funds to. You can include both if you intend to use the payment method for both purposes.\n  * `id` Unique identifier for the object.\n  * `last_setup_error` The error encountered in the previous SetupIntent confirmation.\n  * `latest_attempt` The most recent SetupAttempt for this SetupIntent.\n  * `livemode` Has the value `true` if the object exists in live mode or the value `false` if the object exists in test mode.\n  * `mandate` ID of the multi use Mandate generated by the SetupIntent.\n  * `metadata` Set of [key-value pairs](https://stripe.com/docs/api/metadata) that you can attach to an object. This can be useful for storing additional information about the object in a structured format.\n  * `next_action` If present, this property tells you what actions you need to take in order for your customer to continue payment setup.\n  * `object` String representing the object's type. Objects of the same type share the same value.\n  * `on_behalf_of` The account (if any) for which the setup is intended.\n  * `payment_method` ID of the payment method used with this SetupIntent.\n  * `payment_method_options` Payment-method-specific configuration for this SetupIntent.\n  * `payment_method_types` The list of payment method types (e.g. card) that this SetupIntent is allowed to set up.\n  * `single_use_mandate` ID of the single_use Mandate generated by the SetupIntent.\n  * `status` [Status](https://stripe.com/docs/payments/intents#intent-statuses) of this SetupIntent, one of `requires_payment_method`, `requires_confirmation`, `requires_action`, `processing`, `canceled`, or `succeeded`.\n  * `usage` Indicates how the payment method is intended to be used in the future.\n\nUse `on_session` if you intend to only reuse the payment method when the customer is in your checkout flow. Use `off_session` if your customer may or may not be in your checkout flow. If not provided, this value defaults to `off_session`.\n"
    @type t :: %__MODULE__{
            application: (binary | term) | nil,
            attach_to_self: boolean,
            automatic_payment_methods: term | nil,
            cancellation_reason: binary | nil,
            client_secret: binary | nil,
            created: integer,
            customer: (binary | Stripe.Customer.t() | Stripe.DeletedCustomer.t()) | nil,
            description: binary | nil,
            flow_directions: term | nil,
            id: binary,
            last_setup_error: Stripe.ApiErrors.t() | nil,
            latest_attempt: (binary | Stripe.SetupAttempt.t()) | nil,
            livemode: boolean,
            mandate: (binary | Stripe.Mandate.t()) | nil,
            metadata: term | nil,
            next_action: term | nil,
            object: binary,
            on_behalf_of: (binary | Stripe.Account.t()) | nil,
            payment_method: (binary | Stripe.PaymentMethod.t()) | nil,
            payment_method_options: term | nil,
            payment_method_types: term,
            single_use_mandate: (binary | Stripe.Mandate.t()) | nil,
            status: binary,
            usage: binary
          }
  )

  (
    @typedoc "If this is a `acss_debit` SetupIntent, this sub-hash contains details about the ACSS Debit payment method options."
    @type acss_debit :: %{
            optional(:currency) => :cad | :usd,
            optional(:mandate_options) => mandate_options,
            optional(:verification_method) => :automatic | :instant | :microdeposits
          }
  )

  (
    @typedoc nil
    @type address :: %{
            optional(:city) => binary,
            optional(:country) => binary,
            optional(:line1) => binary,
            optional(:line2) => binary,
            optional(:postal_code) => binary,
            optional(:state) => binary
          }
  )

  (
    @typedoc "If this is an `au_becs_debit` PaymentMethod, this hash contains details about the bank account."
    @type au_becs_debit :: %{optional(:account_number) => binary, optional(:bsb_number) => binary}
  )

  (
    @typedoc "When enabled, this SetupIntent will accept payment methods that you have enabled in the Dashboard and are compatible with this SetupIntent's other parameters."
    @type automatic_payment_methods :: %{
            optional(:allow_redirects) => :always | :never,
            optional(:enabled) => boolean
          }
  )

  (
    @typedoc "If this is a `bacs_debit` PaymentMethod, this hash contains details about the Bacs Direct Debit bank account."
    @type bacs_debit :: %{optional(:account_number) => binary, optional(:sort_code) => binary}
  )

  (
    @typedoc "Billing information associated with the PaymentMethod that may be used or required by particular types of payment methods."
    @type billing_details :: %{
            optional(:address) => address | binary,
            optional(:email) => binary | binary,
            optional(:name) => binary | binary,
            optional(:phone) => binary | binary
          }
  )

  (
    @typedoc "If this is a `boleto` PaymentMethod, this hash contains details about the Boleto payment method."
    @type boleto :: %{optional(:tax_id) => binary}
  )

  (
    @typedoc "Configuration for any card setup attempted on this SetupIntent."
    @type card :: %{
            optional(:mandate_options) => mandate_options,
            optional(:moto) => boolean,
            optional(:network) =>
              :amex
              | :cartes_bancaires
              | :diners
              | :discover
              | :eftpos_au
              | :interac
              | :jcb
              | :mastercard
              | :unionpay
              | :unknown
              | :visa,
            optional(:request_three_d_secure) => :any | :automatic
          }
  )

  (
    @typedoc nil
    @type created :: %{
            optional(:gt) => integer,
            optional(:gte) => integer,
            optional(:lt) => integer,
            optional(:lte) => integer
          }
  )

  (
    @typedoc "This hash contains details about the customer acceptance of the Mandate."
    @type customer_acceptance :: %{
            optional(:accepted_at) => integer,
            optional(:offline) => map(),
            optional(:online) => online,
            optional(:type) => :offline | :online
          }
  )

  (
    @typedoc "Customer's date of birth"
    @type dob :: %{
            optional(:day) => integer,
            optional(:month) => integer,
            optional(:year) => integer
          }
  )

  (
    @typedoc "If this is an `eps` PaymentMethod, this hash contains details about the EPS payment method."
    @type eps :: %{
            optional(:bank) =>
              :arzte_und_apotheker_bank
              | :austrian_anadi_bank_ag
              | :bank_austria
              | :bankhaus_carl_spangler
              | :bankhaus_schelhammer_und_schattera_ag
              | :bawag_psk_ag
              | :bks_bank_ag
              | :brull_kallmus_bank_ag
              | :btv_vier_lander_bank
              | :capital_bank_grawe_gruppe_ag
              | :deutsche_bank_ag
              | :dolomitenbank
              | :easybank_ag
              | :erste_bank_und_sparkassen
              | :hypo_alpeadriabank_international_ag
              | :hypo_bank_burgenland_aktiengesellschaft
              | :hypo_noe_lb_fur_niederosterreich_u_wien
              | :hypo_oberosterreich_salzburg_steiermark
              | :hypo_tirol_bank_ag
              | :hypo_vorarlberg_bank_ag
              | :marchfelder_bank
              | :oberbank_ag
              | :raiffeisen_bankengruppe_osterreich
              | :schoellerbank_ag
              | :sparda_bank_wien
              | :volksbank_gruppe
              | :volkskreditbank_ag
              | :vr_bank_braunau
          }
  )

  (
    @typedoc "Additional fields for Financial Connections Session creation"
    @type financial_connections :: %{
            optional(:permissions) =>
              list(:balances | :ownership | :payment_method | :transactions),
            optional(:prefetch) => list(:balances),
            optional(:return_url) => binary
          }
  )

  (
    @typedoc "If this is an `fpx` PaymentMethod, this hash contains details about the FPX payment method."
    @type fpx :: %{
            optional(:account_holder_type) => :company | :individual,
            optional(:bank) =>
              :affin_bank
              | :agrobank
              | :alliance_bank
              | :ambank
              | :bank_islam
              | :bank_muamalat
              | :bank_of_china
              | :bank_rakyat
              | :bsn
              | :cimb
              | :deutsche_bank
              | :hong_leong_bank
              | :hsbc
              | :kfh
              | :maybank2e
              | :maybank2u
              | :ocbc
              | :pb_enterprise
              | :public_bank
              | :rhb
              | :standard_chartered
              | :uob
          }
  )

  (
    @typedoc "If this is an `ideal` PaymentMethod, this hash contains details about the iDEAL payment method."
    @type ideal :: %{
            optional(:bank) =>
              :abn_amro
              | :asn_bank
              | :bunq
              | :handelsbanken
              | :ing
              | :knab
              | :moneyou
              | :n26
              | :rabobank
              | :regiobank
              | :revolut
              | :sns_bank
              | :triodos_bank
              | :van_lanschot
              | :yoursafe
          }
  )

  (
    @typedoc "If this is a `klarna` PaymentMethod, this hash contains details about the Klarna payment method."
    @type klarna :: %{optional(:dob) => dob}
  )

  (
    @typedoc "If this is a `link` PaymentMethod, this sub-hash contains details about the Link payment method options."
    @type link :: %{optional(:persistent_token) => binary}
  )

  (
    @typedoc nil
    @type mandate_data :: %{optional(:customer_acceptance) => customer_acceptance}
  )

  (
    @typedoc "Configuration options for setting up an eMandate for cards issued in India."
    @type mandate_options :: %{
            optional(:amount) => integer,
            optional(:amount_type) => :fixed | :maximum,
            optional(:currency) => binary,
            optional(:description) => binary,
            optional(:end_date) => integer,
            optional(:interval) => :day | :month | :sporadic | :week | :year,
            optional(:interval_count) => integer,
            optional(:reference) => binary,
            optional(:start_date) => integer,
            optional(:supported_types) => list(:india)
          }
  )

  (
    @typedoc "Additional fields for network related functions"
    @type networks :: %{optional(:requested) => list(:ach | :us_domestic_wire)}
  )

  (
    @typedoc "If this is a Mandate accepted online, this hash contains details about the online acceptance."
    @type online :: %{optional(:ip_address) => binary, optional(:user_agent) => binary}
  )

  (
    @typedoc "If this is a `p24` PaymentMethod, this hash contains details about the P24 payment method."
    @type p24 :: %{
            optional(:bank) =>
              :alior_bank
              | :bank_millennium
              | :bank_nowy_bfg_sa
              | :bank_pekao_sa
              | :banki_spbdzielcze
              | :blik
              | :bnp_paribas
              | :boz
              | :citi_handlowy
              | :credit_agricole
              | :envelobank
              | :etransfer_pocztowy24
              | :getin_bank
              | :ideabank
              | :ing
              | :inteligo
              | :mbank_mtransfer
              | :nest_przelew
              | :noble_pay
              | :pbac_z_ipko
              | :plus_bank
              | :santander_przelew24
              | :tmobile_usbugi_bankowe
              | :toyota_bank
              | :volkswagen_bank
          }
  )

  (
    @typedoc "When included, this hash creates a PaymentMethod that is set as the [`payment_method`](https://stripe.com/docs/api/setup_intents/object#setup_intent_object-payment_method)\nvalue in the SetupIntent."
    @type payment_method_data :: %{
            optional(:pix) => map(),
            optional(:fpx) => fpx,
            optional(:affirm) => map(),
            optional(:acss_debit) => acss_debit,
            optional(:bacs_debit) => bacs_debit,
            optional(:alipay) => map(),
            optional(:giropay) => map(),
            optional(:ideal) => ideal,
            optional(:radar_options) => radar_options,
            optional(:metadata) => %{optional(binary) => binary},
            optional(:link) => map(),
            optional(:promptpay) => map(),
            optional(:cashapp) => map(),
            optional(:oxxo) => map(),
            optional(:interac_present) => map(),
            optional(:us_bank_account) => us_bank_account,
            optional(:zip) => map(),
            optional(:paypal) => map(),
            optional(:boleto) => boleto,
            optional(:konbini) => map(),
            optional(:billing_details) => billing_details,
            optional(:blik) => map(),
            optional(:wechat_pay) => map(),
            optional(:sofort) => sofort,
            optional(:p24) => p24,
            optional(:afterpay_clearpay) => map(),
            optional(:type) =>
              :acss_debit
              | :affirm
              | :afterpay_clearpay
              | :alipay
              | :au_becs_debit
              | :bacs_debit
              | :bancontact
              | :blik
              | :boleto
              | :cashapp
              | :customer_balance
              | :eps
              | :fpx
              | :giropay
              | :grabpay
              | :ideal
              | :klarna
              | :konbini
              | :link
              | :oxxo
              | :p24
              | :paynow
              | :paypal
              | :pix
              | :promptpay
              | :sepa_debit
              | :sofort
              | :us_bank_account
              | :wechat_pay
              | :zip,
            optional(:grabpay) => map(),
            optional(:bancontact) => map(),
            optional(:au_becs_debit) => au_becs_debit,
            optional(:customer_balance) => map(),
            optional(:sepa_debit) => sepa_debit,
            optional(:klarna) => klarna,
            optional(:paynow) => map(),
            optional(:eps) => eps
          }
  )

  (
    @typedoc "Payment-method-specific configuration for this SetupIntent."
    @type payment_method_options :: %{
            optional(:acss_debit) => acss_debit,
            optional(:card) => card,
            optional(:link) => link,
            optional(:paypal) => paypal,
            optional(:sepa_debit) => sepa_debit,
            optional(:us_bank_account) => us_bank_account
          }
  )

  (
    @typedoc "If this is a `paypal` PaymentMethod, this sub-hash contains details about the PayPal payment method options."
    @type paypal :: %{optional(:billing_agreement_id) => binary}
  )

  (
    @typedoc "Options to configure Radar. See [Radar Session](https://stripe.com/docs/radar/radar-session) for more information."
    @type radar_options :: %{optional(:session) => binary}
  )

  (
    @typedoc "If this is a `sepa_debit` PaymentMethod, this hash contains details about the SEPA debit bank account."
    @type sepa_debit :: %{optional(:iban) => binary}
  )

  (
    @typedoc "If this hash is populated, this SetupIntent will generate a single_use Mandate on success."
    @type single_use :: %{optional(:amount) => integer, optional(:currency) => binary}
  )

  (
    @typedoc "If this is a `sofort` PaymentMethod, this hash contains details about the SOFORT payment method."
    @type sofort :: %{optional(:country) => :AT | :BE | :DE | :ES | :IT | :NL}
  )

  (
    @typedoc "If this is an `us_bank_account` PaymentMethod, this hash contains details about the US bank account payment method."
    @type us_bank_account :: %{
            optional(:account_holder_type) => :company | :individual,
            optional(:account_number) => binary,
            optional(:account_type) => :checking | :savings,
            optional(:financial_connections_account) => binary,
            optional(:routing_number) => binary
          }
  )

  (
    nil

    @doc "<p>Creates a SetupIntent object.</p>\n\n<p>After the SetupIntent is created, attach a payment method and <a href=\"/docs/api/setup_intents/confirm\">confirm</a>\nto collect any required permissions to charge the payment method later.</p>\n\n#### Details\n\n * Method: `post`\n * Path: `/v1/setup_intents`\n"
    (
      @spec create(
              params :: %{
                optional(:attach_to_self) => boolean,
                optional(:automatic_payment_methods) => automatic_payment_methods,
                optional(:confirm) => boolean,
                optional(:customer) => binary,
                optional(:description) => binary,
                optional(:expand) => list(binary),
                optional(:flow_directions) => list(:inbound | :outbound),
                optional(:mandate_data) => mandate_data | binary,
                optional(:metadata) => %{optional(binary) => binary},
                optional(:on_behalf_of) => binary,
                optional(:payment_method) => binary,
                optional(:payment_method_data) => payment_method_data,
                optional(:payment_method_options) => payment_method_options,
                optional(:payment_method_types) => list(binary),
                optional(:return_url) => binary,
                optional(:single_use) => single_use,
                optional(:usage) => :off_session | :on_session,
                optional(:use_stripe_sdk) => boolean
              },
              opts :: Keyword.t()
            ) :: {:ok, Stripe.SetupIntent.t()} | {:error, Stripe.ApiErrors.t()} | {:error, term()}
      def create(params \\ %{}, opts \\ []) do
        path = Stripe.OpenApi.Path.replace_path_params("/v1/setup_intents", [], [])

        Stripe.Request.new_request(opts)
        |> Stripe.Request.put_endpoint(path)
        |> Stripe.Request.put_params(params)
        |> Stripe.Request.put_method(:post)
        |> Stripe.Request.make_request()
      end
    )
  )

  (
    nil

    @doc "<p>Returns a list of SetupIntents.</p>\n\n#### Details\n\n * Method: `get`\n * Path: `/v1/setup_intents`\n"
    (
      @spec list(
              params :: %{
                optional(:attach_to_self) => boolean,
                optional(:created) => created | integer,
                optional(:customer) => binary,
                optional(:ending_before) => binary,
                optional(:expand) => list(binary),
                optional(:limit) => integer,
                optional(:payment_method) => binary,
                optional(:starting_after) => binary
              },
              opts :: Keyword.t()
            ) ::
              {:ok, Stripe.List.t(Stripe.SetupIntent.t())}
              | {:error, Stripe.ApiErrors.t()}
              | {:error, term()}
      def list(params \\ %{}, opts \\ []) do
        path = Stripe.OpenApi.Path.replace_path_params("/v1/setup_intents", [], [])

        Stripe.Request.new_request(opts)
        |> Stripe.Request.put_endpoint(path)
        |> Stripe.Request.put_params(params)
        |> Stripe.Request.put_method(:get)
        |> Stripe.Request.make_request()
      end
    )
  )

  (
    nil

    @doc "<p>Retrieves the details of a SetupIntent that has previously been created. </p>\n\n<p>Client-side retrieval using a publishable key is allowed when the <code>client_secret</code> is provided in the query string. </p>\n\n<p>When retrieved with a publishable key, only a subset of properties will be returned. Please refer to the <a href=\"#setup_intent_object\">SetupIntent</a> object reference for more details.</p>\n\n#### Details\n\n * Method: `get`\n * Path: `/v1/setup_intents/{intent}`\n"
    (
      @spec retrieve(
              intent :: binary(),
              params :: %{optional(:client_secret) => binary, optional(:expand) => list(binary)},
              opts :: Keyword.t()
            ) :: {:ok, Stripe.SetupIntent.t()} | {:error, Stripe.ApiErrors.t()} | {:error, term()}
      def retrieve(intent, params \\ %{}, opts \\ []) do
        path =
          Stripe.OpenApi.Path.replace_path_params(
            "/v1/setup_intents/{intent}",
            [
              %OpenApiGen.Blueprint.Parameter{
                in: "path",
                name: "intent",
                required: true,
                schema: %OpenApiGen.Blueprint.Parameter.Schema{
                  name: "intent",
                  title: nil,
                  type: "string",
                  items: [],
                  properties: [],
                  any_of: []
                }
              }
            ],
            [intent]
          )

        Stripe.Request.new_request(opts)
        |> Stripe.Request.put_endpoint(path)
        |> Stripe.Request.put_params(params)
        |> Stripe.Request.put_method(:get)
        |> Stripe.Request.make_request()
      end
    )
  )

  (
    nil

    @doc "<p>Updates a SetupIntent object.</p>\n\n#### Details\n\n * Method: `post`\n * Path: `/v1/setup_intents/{intent}`\n"
    (
      @spec update(
              intent :: binary(),
              params :: %{
                optional(:attach_to_self) => boolean,
                optional(:customer) => binary,
                optional(:description) => binary,
                optional(:expand) => list(binary),
                optional(:flow_directions) => list(:inbound | :outbound),
                optional(:metadata) => %{optional(binary) => binary} | binary,
                optional(:payment_method) => binary,
                optional(:payment_method_data) => payment_method_data,
                optional(:payment_method_options) => payment_method_options,
                optional(:payment_method_types) => list(binary)
              },
              opts :: Keyword.t()
            ) :: {:ok, Stripe.SetupIntent.t()} | {:error, Stripe.ApiErrors.t()} | {:error, term()}
      def update(intent, params \\ %{}, opts \\ []) do
        path =
          Stripe.OpenApi.Path.replace_path_params(
            "/v1/setup_intents/{intent}",
            [
              %OpenApiGen.Blueprint.Parameter{
                in: "path",
                name: "intent",
                required: true,
                schema: %OpenApiGen.Blueprint.Parameter.Schema{
                  name: "intent",
                  title: nil,
                  type: "string",
                  items: [],
                  properties: [],
                  any_of: []
                }
              }
            ],
            [intent]
          )

        Stripe.Request.new_request(opts)
        |> Stripe.Request.put_endpoint(path)
        |> Stripe.Request.put_params(params)
        |> Stripe.Request.put_method(:post)
        |> Stripe.Request.make_request()
      end
    )
  )

  (
    nil

    @doc "<p>Confirm that your customer intends to set up the current or\nprovided payment method. For example, you would confirm a SetupIntent\nwhen a customer hits the “Save” button on a payment method management\npage on your website.</p>\n\n<p>If the selected payment method does not require any additional\nsteps from the customer, the SetupIntent will transition to the\n<code>succeeded</code> status.</p>\n\n<p>Otherwise, it will transition to the <code>requires_action</code> status and\nsuggest additional actions via <code>next_action</code>. If setup fails,\nthe SetupIntent will transition to the\n<code>requires_payment_method</code> status or the <code>canceled</code> status if the\nconfirmation limit is reached.</p>\n\n#### Details\n\n * Method: `post`\n * Path: `/v1/setup_intents/{intent}/confirm`\n"
    (
      @spec confirm(
              intent :: binary(),
              params :: %{
                optional(:expand) => list(binary),
                optional(:mandate_data) => mandate_data | binary | mandate_data,
                optional(:payment_method) => binary,
                optional(:payment_method_data) => payment_method_data,
                optional(:payment_method_options) => payment_method_options,
                optional(:return_url) => binary,
                optional(:use_stripe_sdk) => boolean
              },
              opts :: Keyword.t()
            ) :: {:ok, Stripe.SetupIntent.t()} | {:error, Stripe.ApiErrors.t()} | {:error, term()}
      def confirm(intent, params \\ %{}, opts \\ []) do
        path =
          Stripe.OpenApi.Path.replace_path_params(
            "/v1/setup_intents/{intent}/confirm",
            [
              %OpenApiGen.Blueprint.Parameter{
                in: "path",
                name: "intent",
                required: true,
                schema: %OpenApiGen.Blueprint.Parameter.Schema{
                  name: "intent",
                  title: nil,
                  type: "string",
                  items: [],
                  properties: [],
                  any_of: []
                }
              }
            ],
            [intent]
          )

        Stripe.Request.new_request(opts)
        |> Stripe.Request.put_endpoint(path)
        |> Stripe.Request.put_params(params)
        |> Stripe.Request.put_method(:post)
        |> Stripe.Request.make_request()
      end
    )
  )

  (
    nil

    @doc "<p>A SetupIntent object can be canceled when it is in one of these statuses: <code>requires_payment_method</code>, <code>requires_confirmation</code>, or <code>requires_action</code>. </p>\n\n<p>Once canceled, setup is abandoned and any operations on the SetupIntent will fail with an error.</p>\n\n#### Details\n\n * Method: `post`\n * Path: `/v1/setup_intents/{intent}/cancel`\n"
    (
      @spec cancel(
              intent :: binary(),
              params :: %{
                optional(:cancellation_reason) =>
                  :abandoned | :duplicate | :requested_by_customer,
                optional(:expand) => list(binary)
              },
              opts :: Keyword.t()
            ) :: {:ok, Stripe.SetupIntent.t()} | {:error, Stripe.ApiErrors.t()} | {:error, term()}
      def cancel(intent, params \\ %{}, opts \\ []) do
        path =
          Stripe.OpenApi.Path.replace_path_params(
            "/v1/setup_intents/{intent}/cancel",
            [
              %OpenApiGen.Blueprint.Parameter{
                in: "path",
                name: "intent",
                required: true,
                schema: %OpenApiGen.Blueprint.Parameter.Schema{
                  name: "intent",
                  title: nil,
                  type: "string",
                  items: [],
                  properties: [],
                  any_of: []
                }
              }
            ],
            [intent]
          )

        Stripe.Request.new_request(opts)
        |> Stripe.Request.put_endpoint(path)
        |> Stripe.Request.put_params(params)
        |> Stripe.Request.put_method(:post)
        |> Stripe.Request.make_request()
      end
    )
  )

  (
    nil

    @doc "<p>Verifies microdeposits on a SetupIntent object.</p>\n\n#### Details\n\n * Method: `post`\n * Path: `/v1/setup_intents/{intent}/verify_microdeposits`\n"
    (
      @spec verify_microdeposits(
              intent :: binary(),
              params :: %{
                optional(:amounts) => list(integer),
                optional(:descriptor_code) => binary,
                optional(:expand) => list(binary)
              },
              opts :: Keyword.t()
            ) :: {:ok, Stripe.SetupIntent.t()} | {:error, Stripe.ApiErrors.t()} | {:error, term()}
      def verify_microdeposits(intent, params \\ %{}, opts \\ []) do
        path =
          Stripe.OpenApi.Path.replace_path_params(
            "/v1/setup_intents/{intent}/verify_microdeposits",
            [
              %OpenApiGen.Blueprint.Parameter{
                in: "path",
                name: "intent",
                required: true,
                schema: %OpenApiGen.Blueprint.Parameter.Schema{
                  name: "intent",
                  title: nil,
                  type: "string",
                  items: [],
                  properties: [],
                  any_of: []
                }
              }
            ],
            [intent]
          )

        Stripe.Request.new_request(opts)
        |> Stripe.Request.put_endpoint(path)
        |> Stripe.Request.put_params(params)
        |> Stripe.Request.put_method(:post)
        |> Stripe.Request.make_request()
      end
    )
  )
end
