module MediaWiki
  module Query
    #TODO: Actually decide on a good way to deal with meta information queries.
    # The metainformation could probably be handled in a much less verbose way.
    module Meta

      # Returns an array of all the wiki's file repository names.
      # @return [Array] All wiki's file repository names.
      def get_filerepo_names()
        params = {
          action: 'query',
          meta: 'filerepoinfo',
          friprop: 'name',
          format: 'json'
        }

        result = post(params)
        array = Array.new
        result["query"]["repos"].each do |repo|
          array.push(repo["name"])
        end
        return array
      end
    end

    module Properties

      # Gets the wiki text for the given page. Returns nil if it for some reason cannot get the text, for example, if the page does not exist. Returns a string.
      # @param title [String] The page title
      # @return [String/nil] String containing page contents, or nil
      def get_text(title)
        params = {
          action: 'query',
          prop: 'revisions',
          rvprop: 'content',
          format: 'json',
          titles: title
        }

        response = post(params)
        response["query"]["pages"].each do |revid, data|
          $revid = revid
        end

        if response["query"]["pages"][$revid]["missing"] == ""
          return nil
        else
          return response["query"]["pages"][$revid]["revisions"][0]["*"]
        end
      end
      
      # Gets the revision ID for the given page.
      # @param title [String] The page title
      # @return [Int/nil] the ID or nil
      def get_id(title)
        params = {
          action: 'query',
          prop: 'revisions',
          rvprop: 'content',
          format: 'json',
          titles: title
        }
        
         response = post(params)
         response["query"]["pages"].each do |revid, data|
           if revid != "-1"
             return revid.to_i
           else
             return nil
           end
         end
      end
    end
    
    module Namespaces
      # Constants Namespace IDs. Taken from https://www.mediawiki.org/wiki/Extension_default_namespaces
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

    module Lists

      # Gets an array of backlinks to a given title.
      # @param title [String] The page to get the backlinks of.
      # @param limit [Int] The maximum number of pages to get. Defaults to 500, and cannot be greater than that unless the user is a bot. If the user is a bot, the limit cannot be greater than 5000.
      # @return [Array] All backlinks until the limit
      def what_links_here(title, limit = 500)
        params = {
          action: 'query',
          bltitle: title,
          format: 'json'
        }

        if limit > 500
          if is_current_user_bot() == true
            if limit > 5000
              params[:bllimit] = 5000
            else
              params[:bllimit] = limit
            end
          else
            params[:bllimit] = 500
          end
        else
          params[:bllimit] = limit
        end

        ret = Array.new
        response = post(params)
        response["query"]["backlinks"].each do |bl|
          ret.push(bl["title"])
        end
        return ret
      end

      # Returns an array of all page titles that belong to a given category.
      # @param category [String] The category title. It can include "Category:", or not, it doesn't really matter because we will add it if it is missing.
      # @param limit [Int] The maximum number of members to get. Defaults to 500, and cannot be greater than that unless the user is a bot. If the user is a bot, the limit cannot be greater than 5000.
      # @return [Array] All category members until the limit
      def get_category_members(category, limit = 500)
        params = {
          action: 'query',
          list: 'categorymembers',
          #cmprop: 'title',
          format: 'json'
        }

        if category =~ /[Cc]ategory\:/
          params[:cmtitle] = category
        else
          params[:cmtitle] = "Category:#{category}"
        end

        if limit > 500
          if is_current_user_bot() == true
            if limit > 5000
              params[:cmlimit] = 5000
            else
              params[:cmlimit] = limit
            end
          else
            params[:cmlimit] = 500
          end
        else
          params[:cmlimit] = limit
        end

        ret = Array.new
        response = post(params)
        response["query"]["categorymembers"].each do |cm|
          ret.push(cm["title"])
        end
        return ret
      end
      
      # Returns an array of random pages titles.
      # @param number_of_pages [Int] The number of articles to get. Defaults to 1. Cannot be greater than 10 for normal users, or 20 for bots.
      # @param namespace [Int] The namespace ID. Defaults to '0' (the main namespace). Set to nil for all namespaces.
      # @return [Array] All members
      def get_random_pages(number_of_pages = 1, namespace = 0)
        params = {
          action: 'query',
          list: 'random',
          format: 'json'
        }
        
        params[:rnnamespace] = namespace if namespace != nil
        
        if namespace > 10
          if is_current_user_bot() == true
            if limit > 20
              params[:rnlimit] = 20
            else
              params[:rnlimit] = limit
            end
          else
            params[:rnlimit] = 10
          end
        else
          params[:rnlimit] = namespace
        end
        
        ret = Array.new
        responce = post(params)
        responce["query"]["random"].each do |a|
          ret.push(a["title"])
        end
        return ret
      end
    end
  end
end
