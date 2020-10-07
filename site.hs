--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll
import qualified Data.Set as S
import           Text.Pandoc.Options
import           GHC.IO.Encoding
--------------------------------------------------------------------------------
main :: IO ()
main = do
  setLocaleEncoding utf8
  setFileSystemEncoding utf8
  setForeignEncoding utf8
  hakyll $ do
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match "libraries/bootstrap/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "libraries/mathjax/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "libraries/highlighters/prettify/js/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "libraries/highlighters/prettify/css/*" $ do
        route   idRoute
        compile copyFileCompiler

    match (fromList ["about.rst", "contact.markdown"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    match "posts/figures/*" $ do
        route   idRoute
        compile copyFileCompiler

    -- build up tags
    tags <- buildTags "posts/*" (fromCapture "tags/*.html")

    tagsRules tags $ \tag pattern -> do
        let title = "Posts tagged \"" ++ tag ++ "\""
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll pattern
            let ctx = constField "title" title
                      `mappend` listField "posts" postCtx (return posts)
                      `mappend` defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/tag.html" ctx
                >>= loadAndApplyTemplate "templates/default.html" ctx
                >>= relativizeUrls

    match "posts/*.md" $ do
        route $ setExtension "html"
        compile $ pandocMathCompiler
            >>= loadAndApplyTemplate "templates/post.html" (postCtxWithTags tags)
            >>= saveSnapshot "content"
            >>= loadAndApplyTemplate "templates/info.html" (postCtxWithTags tags)
            >>= relativizeUrls

    create ["archive.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let archiveCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Archives"            `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls


    match "index.html" $ do
        route idRoute
        compile $ do
            posts <- fmap (take 10) . recentFirst =<< loadAll "posts/*"
            let indexCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Home"                `mappend`
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateBodyCompiler

    create ["feed.xml"] $ do
        route idRoute
        compile $ do
            let feedCtx = postCtx `mappend` bodyField "description"
            posts <- fmap (take 10) . recentFirst =<<
                loadAllSnapshots "posts/*" "content"
            rssTemplate <- unsafeCompiler $ readFile "templates/rss.xml"
            rssItemTemplate <- unsafeCompiler $ readFile "templates/rss-item.xml"
            renderRssWithTemplates rssTemplate rssItemTemplate myFeedConfiguration feedCtx posts    

--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    mdField "md" link            `mappend`
    rmdField "rmd" link          `mappend`
    defaultContext
  where link = "https://raw.githubusercontent.com/stla/hakyllsource/master/"

mdField :: String -> String -> Context a
mdField key prefix = field key $ return . ((++) prefix) . toFilePath . itemIdentifier

rmdField :: String -> String -> Context a
rmdField key prefix = field key $ 
  return . ((++) prefix) . (flip (++) "Rmd") . (init . init) . toFilePath . itemIdentifier

postCtxWithTags :: Tags -> Context String
postCtxWithTags tags = tagsField "tags" tags `mappend` postCtx

pandocMathCompiler =
    let mathExtensions = [Ext_tex_math_dollars, Ext_tex_math_double_backslash,
                          Ext_latex_macros]
        defaultExtensions = writerExtensions defaultHakyllWriterOptions
        newExtensions = defaultExtensions <> (extensionsFromList mathExtensions) -- foldr S.insert defaultExtensions mathExtensions
        writerOptions = defaultHakyllWriterOptions {
                          writerExtensions = newExtensions,
                          writerHTMLMathMethod = MathJax ""
                        }
    in pandocCompilerWith defaultHakyllReaderOptions writerOptions

myFeedConfiguration :: FeedConfiguration
myFeedConfiguration = FeedConfiguration
    { feedTitle       = "Saturn Elephant"
    , feedDescription = "A blog about R and more."
    , feedAuthorName  = "Stéphane Laurent"
    , feedAuthorEmail = "laurent_step@outlook.fr"
    , feedRoot        = "https://laustep.github.io/stlahblog"
    }
