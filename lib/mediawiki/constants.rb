module MediaWiki
  module Constants
    # Constants Namespace IDs. Taken from https://www.mediawiki.org/wiki/Extension_default_namespaces
    module Namespaces
      # Core
      $NS_MAIN = 0
      $NS_TALK = 1
      $NS_USER = 2
      $NS_USER_TALK = 3
      $NS_PROJECT = 4
      $NS_PROJECT_TALK = 5
      $NS_FILE = 6
      $NS_FILE_TALK = 7
      $NS_MEDIAWIKI = 8
      $NS_MEDIAWIKI_TALK = 9
      $NS_TEMPLATE = 10
      $NS_TEMPLATE_TALK = 11
      $NS_HELP = 12
      $NS_HELP_TALK = 13
      $NS_CATEGORY = 14
      $NS_CATEGORY_TALK = 15
      $NS_SPECIAL = -1
      $NS_MEDIA = -2

      # Extension:LiquidThreads
      $NS_LQT_THREAD = 90
      $NS_LQT_THREAD_TALK = 91
      $NS_LQT_SUMMARY = 92
      $NS_LQT_SUMMARY_TALK = 93

      # Extension:Semantic MediaWiki / Extension:Semantic Forms
      $NS_SMW_RELATION = 100
      $NS_SMW_RELATION_TALK = 101
      $NS_SMW_PROPERTY = 102
      $NS_SMW_PROPERTY_TALK = 103
      $NS_SMW_TYPE = 104
      $NS_SMW_TYPE_TALK = 105
      $NS_SMW_FORM = 106
      $NS_SMW_FORM_TALK = 107
      $NS_SF_CONCEPT = 108
      $NS_SF_CONCEPT_TALK = 109

      # Extension:DPLforum
      $NS_DPLF_FORUM = 110
      $NS_DPLF_FORUM_TAlK = 111

      # Extension:RefHelper
      $NS_RFH_CITE = 120
      $NS_RFH_CITE_TALK = 121

      # Extension:SemanticAccessControl
      $NS_ACL_USERGROUP = 160
      $NS_ACL_ACL = 162

      # Extension:Semantic Drilldown
      $NS_SED_FILTER = 170
      $NS_SED_FILTER_TALK = 171

      # Extension:SocialProfile
      $NS_SCP_USERWIKI = 200
      $NS_SCP_USERWIKI_TALK = 201
      $NS_SCP_USERPROFILE = 202
      $NS_SCP_USERPROFILE_TALK = 203

      # Extension:Proofread Page
      $NS_PRP_PAGE = 250
      $NS_PRP_PAGE_TALK = 251
      $NS_PRP_INDEX = 252
      $NS_PRP_INDEX_TALK = 253

      # Extension:TrustedMath
      $NS_TRM_MATH = 262
      $NS_TRM_MATH_TALK = 263

      # Extension:Widgets
      $NS_WID_WIDGET = 274
      $NS_WID_WIDGET_TALK = 275

      # Extension:EmbedScript
      $NS_EMS_JSAPPLET = 280
      $NS_EMS_JSAPPLET_TALK = 281

      # Extension:PollNY
      $NS_PLN_POLL = 300
      $NS_PLN_POLL_TALK = 301

      # Extension:Semantic Image Annotator
      $NS_SIA_IMAGE_ANNOTATOR = 380

      # Extension:Wiki2LaTeX
      $NS_WTL_WIKI2LATEX = 400
      $NS_WTL_WIKI2LATEX_TALK = 401

      # Extension:Workflow
      $NS_WRF_WORKFLOW = 410
      $NS_WRF_WORKFLOW_TALK = 411

      # Extension:Maps
      $NS_MAP_LAYER = 420
      $NS_MAP_LAYER_TALK = 421

      # Extension:QuizTabulate
      $NS_QTB_QUIZ = 430
      $NS_QTB_QUIZ_TALK = 431

      # Extension:Education Program
      $NS_EDP_EDUCATION_PROGRAM = 446
      $NS_EDP_EDUCATION_PROGRAM_TALK = 447

      # Extension:BoilerRoom
      $NS_BLR_BOILERPLATE = 450
      $NS_BLR_BOILERPLATE_TALK = 451

      # Extension:UploadWizard
      $NS_UPW_CAMPAIGN = 460
      $NS_UPW_CAMPAIGN_TALK = 461

      # Extension:EventLogging
      $NS_ELG_SCHEMA = 470
      $NS_ELG_SCHEMA_TALK = 471

      # Extension:ZeroBanner
      $NS_ZRB_ZERO = 480
      $NS_ZRB_ZERO_TALK = 481

      # Extension:JsonConfig
      $NS_JSC_CONFIG = 482
      $NS_JSC_CONFIG_TALK = 483
      $NS_JSC_DATA = 486
      $NS_JSC_DATA_TALK = 487

      # Extension:Graph
      $NS_GRP_GRAPH = 484
      $NS_GRP_GRAPH_TALK = 485

      # Extension:OpenStackManager
      $NS_OSM_NOVA_RESOURCE = 488
      $NS_OSM_NOVA_RESOURCE_TALK = 489

      # Extension:GWToolset
      $NS_GWT_GWTOOLSET = 490
      $NS_GWT_GWTOOLSET_TALK = 491

      # Extension:BlogPage
      $NS_BLP_BLOG = 500
      $NS_BLP_BLOG_TALK = 501

      # Extension:XMLContentExtension
      $NS_XCE_XML = 580
      $NS_XCE_XML_TALK = 581
      $NS_XCE_SCHEMA = 582
      $NS_XCE_SCHEMA_TALK = 583

      # Extension:FanBoxes
      $NS_FNB_USERBOX = 600
      $NS_FNB_USERBOX_TALK = 601

      # Extension:LinkFilter
      $NS_LFT_LINK = 700
      $NS_LFT_LINK_TALK = 701

      # Extension:TimedMediaHandler
      $NS_TMH_TIMEDTEXT = 710
      $NS_TMH_TIMEDTEXT_TALK = 711

      # Extension:QPoll
      $NS_QPL_INTERPRETATION = 800
      $NS_QPL_INTERPRETATION_TALK = 801

      # Extension:SemanticMustacheFormat :3
      $NS_SMF_MUSTACHE = 806
      $NS_SMF_MUSTACHE_TALK = 807

      # Extension:R
      $NS_R_R = 814
      $NS_R_R_TALK = 815

      # Extension:Scribunto
      $NS_SCR_MODULE = 828
      $NS_SCR_MODULE_TALK = 829

      # Extension:SecurePoll
      $NS_SEP_SECUREPOLL = 830
      $NS_SEP_SECUREPOLL_TALK = 831

      # Extension:CentralNotice
      $NS_CNT_CNBANNER = 866
      $NS_CNT_CNBANNER_TALK = 867

      # Extension:Translate
      $NS_TRN_TRANSLATIONS = 1198
      $NS_TRN_TRANSLATIONS_TALK = 1199

      # Extension:PackageForce
      $NS_PKF_PACKAGEFORCE = 1300
      $NS_PKF_PACKAGEFORCE_TALK = 1301

      # Extension:BlueSpice
      $NS_BLS_BLOG = 1502
      $NS_BLS_BLOG_TALK = 1503
      $NS_BLS_BOOK = 1504
      $NS_BLS_BOOK_TALK = 1505

      # Extension:Gadgets
      $NS_GDG_GADGET = 2300
      $NS_GDG_GADGET_TALK = 2301
      $NS_GDG_GADGET_DEFININTION = 2302
      $NS_GDG_GADGET_DEFININTION_TALK = 2303

      # Extension:VisualEditor
      $NS_VSE_VISUALEDITOR = 2500
      $NS_VSE_VISUALEDITOR_TALK = 2501

      # Extension:Flow
      $NS_FLW_TOPIC = 2600
    end
  end
end
