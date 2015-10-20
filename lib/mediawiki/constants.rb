module MediaWiki
  module Constants
    # Taken from https://www.mediawiki.org/wiki/Extension_default_namespaces
    NAMESPACES = {
      'MAIN' => 0,
      'TALK' => 1,
      'USER' => 2,
      'USER_TALK' => 3,
      'PROJECT' => 4,
      'PROJECT_TALK' => 5,
      'FILE' => 6,
      'FILE_TALK' => 7,
      'MEDIAWIKI' => 8,
      'MEDIAWIKI_TALK' => 9,
      'TEMPLATE' => 10,
      'TEMPLATE_TALK' => 11,
      'HELP' => 12,
      'HELP_TALK' => 13,
      'CATEGORY' => 14,
      'CATEGORY_TALK' => 15,
      'SPECIAL' => -1,
      'MEDIA' => -2,

      # Extension:LiquidThreads
      'LQT_THREAD' => 90,
      'LQT_THREAD_TALK' => 91,
      'LQT_SUMMARY' => 92,
      'LQT_SUMMARY_TALK' => 93,

      # Extension:Semantic MediaWiki / Extension:Semantic Forms
      'SMW_RELATION' => 100,
      'SMW_RELATION_TALK' => 101,
      'SMW_PROPERTY' => 102,
      'SMW_PROPERTY_TALK' => 103,
      'SMW_TYPE' => 104,
      'SMW_TYPE_TALK' => 105,
      'SMW_FORM' => 106,
      'SMW_FORM_TALK' => 107,
      'SF_CONCEPT' => 108,
      'SF_CONCEPT_TALK' => 109,

      # Extension:DPLforum
      'DPLF_FORUM' => 110,
      'DPLF_FORUM_TAlK' => 111,

      # Extension:RefHelper
      'RFH_CITE' => 120,
      'RFH_CITE_TALK' => 121,

      # Extension:SemanticAccessControl
      'ACL_USERGROUP' => 160,
      'ACL_ACL' => 162,

      # Extension:Semantic Drilldown
      'SED_FILTER' => 170,
      'SED_FILTER_TALK' => 171,

      # Extension:SocialProfile
      'SCP_USERWIKI' => 200,
      'SCP_USERWIKI_TALK' => 201,
      'SCP_USERPROFILE' => 202,
      'SCP_USERPROFILE_TALK' => 203,

      # Extension:Proofread Page
      'PRP_PAGE' => 250,
      'PRP_PAGE_TALK' => 251,
      'PRP_INDEX' => 252,
      'PRP_INDEX_TALK' => 253,

      # Extension:TrustedMath
      'TRM_MATH' => 262,
      'TRM_MATH_TALK' => 263,

      # Extension:Widgets
      'WID_WIDGET' => 274,
      'WID_WIDGET_TALK' => 275,

      # Extension:EmbedScript
      'EMS_JSAPPLET' => 280,
      'EMS_JSAPPLET_TALK' => 281,

      # Extension:PollNY
      'PLN_POLL' => 300,
      'PLN_POLL_TALK' => 301,

      # Extension:Semantic Image Annotator
      'SIA_IMAGE_ANNOTATOR' => 380,

      # Extension:Wiki2LaTeX
      'WTL_WIKI2LATEX' => 400,
      'WTL_WIKI2LATEX_TALK' => 401,

      # Extension:Workflow
      'WRF_WORKFLOW' => 410,
      'WRF_WORKFLOW_TALK' => 411,

      # Extension:Maps
      'MAP_LAYER' => 420,
      'MAP_LAYER_TALK' => 421,

      # Extension:QuizTabulate
      'QTB_QUIZ' => 430,
      'QTB_QUIZ_TALK' => 431,

      # Extension:Education Program
      'EDP_EDUCATION_PROGRAM' => 446,
      'EDP_EDUCATION_PROGRAM_TALK' => 447,

      # Extension:BoilerRoom
      'BLR_BOILERPLATE' => 450,
      'BLR_BOILERPLATE_TALK' => 451,

      # Extension:UploadWizard
      'UPW_CAMPAIGN' => 460,
      'UPW_CAMPAIGN_TALK' => 461,

      # Extension:EventLogging
      'ELG_SCHEMA' => 470,
      'ELG_SCHEMA_TALK' => 471,

      # Extension:ZeroBanner
      'ZRB_ZERO' => 480,
      'ZRB_ZERO_TALK' => 481,

      # Extension:JsonConfig
      'JSC_CONFIG' => 482,
      'JSC_CONFIG_TALK' => 483,
      'JSC_DATA' => 486,
      'JSC_DATA_TALK' => 487,

      # Extension:Graph
      'GRP_GRAPH' => 484,
      'GRP_GRAPH_TALK' => 485,

      # Extension:OpenStackManager
      'OSM_NOVA_RESOURCE' => 488,
      'OSM_NOVA_RESOURCE_TALK' => 489,

      # Extension:GWToolset
      'GWT_GWTOOLSET' => 490,
      'GWT_GWTOOLSET_TALK' => 491,

      # Extension:BlogPage
      'BLP_BLOG' => 500,
      'BLP_BLOG_TALK' => 501,

      # Extension:XMLContentExtension
      'XCE_XML' => 580,
      'XCE_XML_TALK' => 581,
      'XCE_SCHEMA' => 582,
      'XCE_SCHEMA_TALK' => 583,

      # Extension:FanBoxes
      'FNB_USERBOX' => 600,
      'FNB_USERBOX_TALK' => 601,

      # Extension:LinkFilter
      'LFT_LINK' => 700,
      'LFT_LINK_TALK' => 701,

      # Extension:TimedMediaHandler
      'TMH_TIMEDTEXT' => 710,
      'TMH_TIMEDTEXT_TALK' => 711,

      # Extension:QPoll
      'QPL_INTERPRETATION' => 800,
      'QPL_INTERPRETATION_TALK' => 801,

      # Extension:SemanticMustacheFormat :3,
      'SMF_MUSTACHE' => 806,
      'SMF_MUSTACHE_TALK' => 807,

      # Extension:R
      'R_R' => 814,
      'R_R_TALK' => 815,

      # Extension:Scribunto
      'SCR_MODULE' => 828,
      'SCR_MODULE_TALK' => 829,

      # Extension:SecurePoll
      'SEP_SECUREPOLL' => 830,
      'SEP_SECUREPOLL_TALK' => 831,

      # Extension:CentralNotice
      'CNT_CNBANNER' => 866,
      'CNT_CNBANNER_TALK' => 867,

      # Extension:Translate
      'TRN_TRANSLATIONS' => 1198,
      'TRN_TRANSLATIOTALK' => 1199,

      # Extension:PackageForce
      'PKF_PACKAGEFORCE' => 1300,
      'PKF_PACKAGEFORCE_TALK' => 1301,

      # Extension:BlueSpice
      'BLS_BLOG' => 1502,
      'BLS_BLOG_TALK' => 1503,
      'BLS_BOOK' => 1504,
      'BLS_BOOK_TALK' => 1505,

      # Extension:Gadgets
      'GDG_GADGET' => 2300,
      'GDG_GADGET_TALK' => 2301,
      'GDG_GADGET_DEFININTION' => 2302,
      'GDG_GADGET_DEFININTION_TALK' => 2303,

      # Extension:VisualEditor
      'VSE_VISUALEDITOR' => 2500,
      'VSE_VISUALEDITOR_TALK' => 2501,

      # Extension:Flow
      'FLW_TOPIC' => 2600
    }
  end
end
