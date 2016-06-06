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
      'MAIN'.freeze => 0.freeze,
      'TALK'.freeze => 1.freeze,
      'USER'.freeze => 2.freeze,
      'USER_TALK'.freeze => 3.freeze,
      'PROJECT'.freeze => 4.freeze,
      'PROJECT_TALK'.freeze => 5.freeze,
      'FILE'.freeze => 6.freeze,
      'FILE_TALK'.freeze => 7.freeze,
      'MEDIAWIKI'.freeze => 8.freeze,
      'MEDIAWIKI_TALK'.freeze => 9.freeze,
      'TEMPLATE'.freeze => 10.freeze,
      'TEMPLATE_TALK'.freeze => 11.freeze,
      'HELP'.freeze => 12.freeze,
      'HELP_TALK'.freeze => 13.freeze,
      'CATEGORY'.freeze => 14.freeze,
      'CATEGORY_TALK'.freeze => 15.freeze,
      'SPECIAL'.freeze => -1.freeze,
      'MEDIA'.freeze => -2.freeze,

      # Extension:LiquidThreads
      'LQT_THREAD'.freeze => 90.freeze,
      'LQT_THREAD_TALK'.freeze => 91.freeze,
      'LQT_SUMMARY'.freeze => 92.freeze,
      'LQT_SUMMARY_TALK'.freeze => 93.freeze,

      # Extension:Semantic MediaWiki / Extension:Semantic Forms
      'SMW_RELATION'.freeze => 100.freeze,
      'SMW_RELATION_TALK'.freeze => 101.freeze,
      'SMW_PROPERTY'.freeze => 102.freeze,
      'SMW_PROPERTY_TALK'.freeze => 103.freeze,
      'SMW_TYPE'.freeze => 104.freeze,
      'SMW_TYPE_TALK'.freeze => 105.freeze,
      'SMW_FORM'.freeze => 106.freeze,
      'SMW_FORM_TALK'.freeze => 107.freeze,
      'SF_CONCEPT'.freeze => 108.freeze,
      'SF_CONCEPT_TALK'.freeze => 109.freeze,

      # Extension:DPLforum
      'DPLF_FORUM'.freeze => 110.freeze,
      'DPLF_FORUM_TAlK'.freeze => 111.freeze,

      # Extension:RefHelper
      'RFH_CITE'.freeze => 120.freeze,
      'RFH_CITE_TALK'.freeze => 121.freeze,

      # Extension:SemanticAccessControl
      'ACL_USERGROUP'.freeze => 160.freeze,
      'ACL_ACL'.freeze => 162.freeze,

      # Extension:Semantic Drilldown
      'SED_FILTER'.freeze => 170.freeze,
      'SED_FILTER_TALK'.freeze => 171.freeze,

      # Extension:SocialProfile
      'SCP_USERWIKI'.freeze => 200.freeze,
      'SCP_USERWIKI_TALK'.freeze => 201.freeze,
      'SCP_USERPROFILE'.freeze => 202.freeze,
      'SCP_USERPROFILE_TALK'.freeze => 203.freeze,

      # Extension:Proofread Page
      'PRP_PAGE'.freeze => 250.freeze,
      'PRP_PAGE_TALK'.freeze => 251.freeze,
      'PRP_INDEX'.freeze => 252.freeze,
      'PRP_INDEX_TALK'.freeze => 253.freeze,

      # Extension:TrustedMath
      'TRM_MATH'.freeze => 262.freeze,
      'TRM_MATH_TALK'.freeze => 263.freeze,

      # Extension:Widgets
      'WID_WIDGET'.freeze => 274.freeze,
      'WID_WIDGET_TALK'.freeze => 275.freeze,

      # Extension:EmbedScript
      'EMS_JSAPPLET'.freeze => 280.freeze,
      'EMS_JSAPPLET_TALK'.freeze => 281.freeze,

      # Extension:PollNY
      'PLN_POLL'.freeze => 300.freeze,
      'PLN_POLL_TALK'.freeze => 301.freeze,

      # Extension:Semantic Image Annotator
      'SIA_IMAGE_ANNOTATOR'.freeze => 380.freeze,

      # Extension:Wiki2LaTeX
      'WTL_WIKI2LATEX'.freeze => 400.freeze,
      'WTL_WIKI2LATEX_TALK'.freeze => 401.freeze,

      # Extension:Workflow
      'WRF_WORKFLOW'.freeze => 410.freeze,
      'WRF_WORKFLOW_TALK'.freeze => 411.freeze,

      # Extension:Maps
      'MAP_LAYER'.freeze => 420.freeze,
      'MAP_LAYER_TALK'.freeze => 421.freeze,

      # Extension:QuizTabulate
      'QTB_QUIZ'.freeze => 430.freeze,
      'QTB_QUIZ_TALK'.freeze => 431.freeze,

      # Extension:Education Program
      'EDP_EDUCATION_PROGRAM'.freeze => 446.freeze,
      'EDP_EDUCATION_PROGRAM_TALK'.freeze => 447.freeze,

      # Extension:BoilerRoom
      'BLR_BOILERPLATE'.freeze => 450.freeze,
      'BLR_BOILERPLATE_TALK'.freeze => 451.freeze,

      # Extension:UploadWizard
      'UPW_CAMPAIGN'.freeze => 460.freeze,
      'UPW_CAMPAIGN_TALK'.freeze => 461.freeze,

      # Extension:EventLogging
      'ELG_SCHEMA'.freeze => 470.freeze,
      'ELG_SCHEMA_TALK'.freeze => 471.freeze,

      # Extension:ZeroBanner
      'ZRB_ZERO'.freeze => 480.freeze,
      'ZRB_ZERO_TALK'.freeze => 481.freeze,

      # Extension:JsonConfig
      'JSC_CONFIG'.freeze => 482.freeze,
      'JSC_CONFIG_TALK'.freeze => 483.freeze,
      'JSC_DATA'.freeze => 486.freeze,
      'JSC_DATA_TALK'.freeze => 487.freeze,

      # Extension:Graph
      'GRP_GRAPH'.freeze => 484.freeze,
      'GRP_GRAPH_TALK'.freeze => 485.freeze,

      # Extension:OpenStackManager
      'OSM_NOVA_RESOURCE'.freeze => 488.freeze,
      'OSM_NOVA_RESOURCE_TALK'.freeze => 489.freeze,

      # Extension:GWToolset
      'GWT_GWTOOLSET'.freeze => 490.freeze,
      'GWT_GWTOOLSET_TALK'.freeze => 491.freeze,

      # Extension:BlogPage
      'BLP_BLOG'.freeze => 500.freeze,
      'BLP_BLOG_TALK'.freeze => 501.freeze,

      # Extension:XMLContentExtension
      'XCE_XML'.freeze => 580.freeze,
      'XCE_XML_TALK'.freeze => 581.freeze,
      'XCE_SCHEMA'.freeze => 582.freeze,
      'XCE_SCHEMA_TALK'.freeze => 583.freeze,

      # Extension:FanBoxes
      'FNB_USERBOX'.freeze => 600.freeze,
      'FNB_USERBOX_TALK'.freeze => 601.freeze,

      # Extension:LinkFilter
      'LFT_LINK'.freeze => 700.freeze,
      'LFT_LINK_TALK'.freeze => 701.freeze,

      # Extension:TimedMediaHandler
      'TMH_TIMEDTEXT'.freeze => 710.freeze,
      'TMH_TIMEDTEXT_TALK'.freeze => 711.freeze,

      # Extension:QPoll
      'QPL_INTERPRETATION'.freeze => 800.freeze,
      'QPL_INTERPRETATION_TALK'.freeze => 801.freeze,

      # Extension:SemanticMustacheFormat :3
      'SMF_MUSTACHE'.freeze => 806.freeze,
      'SMF_MUSTACHE_TALK'.freeze => 807.freeze,

      # Extension:R
      'R_R'.freeze => 814.freeze,
      'R_R_TALK'.freeze => 815.freeze,

      # Extension:Scribunto
      'SCR_MODULE'.freeze => 828.freeze,
      'SCR_MODULE_TALK'.freeze => 829.freeze,

      # Extension:SecurePoll
      'SEP_SECUREPOLL'.freeze => 830.freeze,
      'SEP_SECUREPOLL_TALK'.freeze => 831.freeze,

      # Extension:CentralNotice
      'CNT_CNBANNER'.freeze => 866.freeze,
      'CNT_CNBANNER_TALK'.freeze => 867.freeze,

      # Extension:Translate
      'TRN_TRANSLATIONS'.freeze => 1198.freeze,
      'TRN_TRANSLATIOTALK'.freeze => 1199.freeze,

      # Extension:PackageForce
      'PKF_PACKAGEFORCE'.freeze => 1300.freeze,
      'PKF_PACKAGEFORCE_TALK'.freeze => 1301.freeze,

      # Extension:BlueSpice
      'BLS_BLOG'.freeze => 1502.freeze,
      'BLS_BLOG_TALK'.freeze => 1503.freeze,
      'BLS_BOOK'.freeze => 1504.freeze,
      'BLS_BOOK_TALK'.freeze => 1505.freeze,

      # Extension:Gadgets
      'GDG_GADGET'.freeze => 2300.freeze,
      'GDG_GADGET_TALK'.freeze => 2301.freeze,
      'GDG_GADGET_DEFININTION'.freeze => 2302.freeze,
      'GDG_GADGET_DEFININTION_TALK'.freeze => 2303.freeze,

      # Extension:VisualEditor
      'VSE_VISUALEDITOR'.freeze => 2500.freeze,
      'VSE_VISUALEDITOR_TALK'.freeze => 2501.freeze,

      # Extension:Flow
      'FLW_TOPIC'.freeze => 2600.freeze
    }.freeze
  end
end
