module MediaWiki
  module Constants
    # @since 0.2.0 as a module with individual global constants
    # @since 0.4.0 as a module with a single global hash identical to this.
    # @since 0.8.0 as its current state.
    # @see https://www.mediawiki.org/wiki/Extension_default_namespaces MediaWiki's list of extension namespace IDs
    #   and names.
    # @return [Hash<String, Fixnum>] The upcased namespace names, and their according ID. The keys, values, and
    #   return value itself are all immutable.
    NAMESPACES = {
      'MAIN'.freeze => 0,
      'TALK'.freeze => 1,
      'USER'.freeze => 2,
      'USER_TALK'.freeze => 3,
      'PROJECT'.freeze => 4,
      'PROJECT_TALK'.freeze => 5,
      'FILE'.freeze => 6,
      'FILE_TALK'.freeze => 7,
      'MEDIAWIKI'.freeze => 8,
      'MEDIAWIKI_TALK'.freeze => 9,
      'TEMPLATE'.freeze => 10,
      'TEMPLATE_TALK'.freeze => 11,
      'HELP'.freeze => 12,
      'HELP_TALK'.freeze => 13,
      'CATEGORY'.freeze => 14,
      'CATEGORY_TALK'.freeze => 15,
      'SPECIAL'.freeze => -1,
      'MEDIA'.freeze => -2,

      # Extension:LiquidThreads
      'LQT_THREAD'.freeze => 90,
      'LQT_THREAD_TALK'.freeze => 91,
      'LQT_SUMMARY'.freeze => 92,
      'LQT_SUMMARY_TALK'.freeze => 93,

      # Extension:Semantic MediaWiki / Extension:Semantic Forms
      'SMW_RELATION'.freeze => 100,
      'SMW_RELATION_TALK'.freeze => 101,
      'SMW_PROPERTY'.freeze => 102,
      'SMW_PROPERTY_TALK'.freeze => 103,
      'SMW_TYPE'.freeze => 104,
      'SMW_TYPE_TALK'.freeze => 105,
      'SMW_FORM'.freeze => 106,
      'SMW_FORM_TALK'.freeze => 107,
      'SF_CONCEPT'.freeze => 108,
      'SF_CONCEPT_TALK'.freeze => 109,

      # Extension:DPLforum
      'DPLF_FORUM'.freeze => 110,
      'DPLF_FORUM_TAlK'.freeze => 111,

      # Extension:RefHelper
      'RFH_CITE'.freeze => 120,
      'RFH_CITE_TALK'.freeze => 121,

      # Extension:SemanticAccessControl
      'ACL_USERGROUP'.freeze => 160,
      'ACL_ACL'.freeze => 162,

      # Extension:Semantic Drilldown
      'SED_FILTER'.freeze => 170,
      'SED_FILTER_TALK'.freeze => 171,

      # Extension:SocialProfile
      'SCP_USERWIKI'.freeze => 200,
      'SCP_USERWIKI_TALK'.freeze => 201,
      'SCP_USERPROFILE'.freeze => 202,
      'SCP_USERPROFILE_TALK'.freeze => 203,

      # Extension:Proofread Page
      'PRP_PAGE'.freeze => 250,
      'PRP_PAGE_TALK'.freeze => 251,
      'PRP_INDEX'.freeze => 252,
      'PRP_INDEX_TALK'.freeze => 253,

      # Extension:TrustedMath
      'TRM_MATH'.freeze => 262,
      'TRM_MATH_TALK'.freeze => 263,

      # Extension:Widgets
      'WID_WIDGET'.freeze => 274,
      'WID_WIDGET_TALK'.freeze => 275,

      # Extension:EmbedScript
      'EMS_JSAPPLET'.freeze => 280,
      'EMS_JSAPPLET_TALK'.freeze => 281,

      # Extension:PollNY
      'PLN_POLL'.freeze => 300,
      'PLN_POLL_TALK'.freeze => 301,

      # Extension:Semantic Image Annotator
      'SIA_IMAGE_ANNOTATOR'.freeze => 380,

      # Extension:Wiki2LaTeX
      'WTL_WIKI2LATEX'.freeze => 400,
      'WTL_WIKI2LATEX_TALK'.freeze => 401,

      # Extension:Workflow
      'WRF_WORKFLOW'.freeze => 410,
      'WRF_WORKFLOW_TALK'.freeze => 411,

      # Extension:Maps
      'MAP_LAYER'.freeze => 420,
      'MAP_LAYER_TALK'.freeze => 421,

      # Extension:QuizTabulate
      'QTB_QUIZ'.freeze => 430,
      'QTB_QUIZ_TALK'.freeze => 431,

      # Extension:Education Program
      'EDP_EDUCATION_PROGRAM'.freeze => 446,
      'EDP_EDUCATION_PROGRAM_TALK'.freeze => 447,

      # Extension:BoilerRoom
      'BLR_BOILERPLATE'.freeze => 450,
      'BLR_BOILERPLATE_TALK'.freeze => 451,

      # Extension:UploadWizard
      'UPW_CAMPAIGN'.freeze => 460,
      'UPW_CAMPAIGN_TALK'.freeze => 461,

      # Extension:EventLogging
      'ELG_SCHEMA'.freeze => 470,
      'ELG_SCHEMA_TALK'.freeze => 471,

      # Extension:ZeroBanner
      'ZRB_ZERO'.freeze => 480,
      'ZRB_ZERO_TALK'.freeze => 481,

      # Extension:JsonConfig
      'JSC_CONFIG'.freeze => 482,
      'JSC_CONFIG_TALK'.freeze => 483,
      'JSC_DATA'.freeze => 486,
      'JSC_DATA_TALK'.freeze => 487,

      # Extension:Graph
      'GRP_GRAPH'.freeze => 484,
      'GRP_GRAPH_TALK'.freeze => 485,

      # Extension:OpenStackManager
      'OSM_NOVA_RESOURCE'.freeze => 488,
      'OSM_NOVA_RESOURCE_TALK'.freeze => 489,

      # Extension:GWToolset
      'GWT_GWTOOLSET'.freeze => 490,
      'GWT_GWTOOLSET_TALK'.freeze => 491,

      # Extension:BlogPage
      'BLP_BLOG'.freeze => 500,
      'BLP_BLOG_TALK'.freeze => 501,

      # Extension:XMLContentExtension
      'XCE_XML'.freeze => 580,
      'XCE_XML_TALK'.freeze => 581,
      'XCE_SCHEMA'.freeze => 582,
      'XCE_SCHEMA_TALK'.freeze => 583,

      # Extension:FanBoxes
      'FNB_USERBOX'.freeze => 600,
      'FNB_USERBOX_TALK'.freeze => 601,

      # Extension:LinkFilter
      'LFT_LINK'.freeze => 700,
      'LFT_LINK_TALK'.freeze => 701,

      # Extension:TimedMediaHandler
      'TMH_TIMEDTEXT'.freeze => 710,
      'TMH_TIMEDTEXT_TALK'.freeze => 711,

      # Extension:QPoll
      'QPL_INTERPRETATION'.freeze => 800,
      'QPL_INTERPRETATION_TALK'.freeze => 801,

      # Extension:SemanticMustacheFormat :3
      'SMF_MUSTACHE'.freeze => 806,
      'SMF_MUSTACHE_TALK'.freeze => 807,

      # Extension:R
      'R_R'.freeze => 814,
      'R_R_TALK'.freeze => 815,

      # Extension:Scribunto
      'SCR_MODULE'.freeze => 828,
      'SCR_MODULE_TALK'.freeze => 829,

      # Extension:SecurePoll
      'SEP_SECUREPOLL'.freeze => 830,
      'SEP_SECUREPOLL_TALK'.freeze => 831,

      # Extension:CentralNotice
      'CNT_CNBANNER'.freeze => 866,
      'CNT_CNBANNER_TALK'.freeze => 867,

      # Extension:Translate
      'TRN_TRANSLATIONS'.freeze => 1198,
      'TRN_TRANSLATIOTALK'.freeze => 1199,

      # Extension:PackageForce
      'PKF_PACKAGEFORCE'.freeze => 1300,
      'PKF_PACKAGEFORCE_TALK'.freeze => 1301,

      # Extension:BlueSpice
      'BLS_BLOG'.freeze => 1502,
      'BLS_BLOG_TALK'.freeze => 1503,
      'BLS_BOOK'.freeze => 1504,
      'BLS_BOOK_TALK'.freeze => 1505,

      # Extension:Gadgets
      'GDG_GADGET'.freeze => 2300,
      'GDG_GADGET_TALK'.freeze => 2301,
      'GDG_GADGET_DEFININTION'.freeze => 2302,
      'GDG_GADGET_DEFININTION_TALK'.freeze => 2303,

      # Extension:VisualEditor
      'VSE_VISUALEDITOR'.freeze => 2500,
      'VSE_VISUALEDITOR_TALK'.freeze => 2501,

      # Extension:Flow
      'FLW_TOPIC'.freeze => 2600
    }.freeze

    # @return [Proc] A proc that returns the missing page ID, -1. This is useful for using methods like Enumerable#find
    #   and not creating a new Proc object for every call.
    MISSING_PAGEID_PROC = Proc.new { '-1' }
  end
end
