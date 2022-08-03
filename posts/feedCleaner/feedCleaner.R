library(xml2)
setwd("~/Documents/SaturnElephant/hakyllsource/_site")

file.copy("feed.xml", "feed.bak.xml", overwrite = TRUE)

feed <- read_xml("feed.xml", encoding = "UTF-8")

# xml_remove(xml_find_all(feed, ".//pubDate"))
# xml_remove(xml_find_all(feed, ".//title")[-1])

descriptions <- xml_find_all(feed, ".//description")


for(i in 2L:length(descriptions)){
  
  htmlString <- xml_text(descriptions[[i]])
  post <- read_html(htmlString)
  body <- xml_find_first(post, ".//body")
  containerDiv <- xml_child(body) 
  
  xml_remove(xml_children(containerDiv)[[2L]])
  
  infos <- xml_find_all(containerDiv, '//*[@class="info"]')
  xml_remove(infos)
  titles <- xml_find_all(containerDiv, '//*[@class="content"]/h1[1]')
  xml_remove(titles)
  
  
  #xml_remove(xml_find_first(containerDiv, '//*[@id="logo"]'))
  
  main <- xml_find_first(containerDiv, '//*[@class="main col-sm-10"]')
  invisible(xml_replace(xml_children(containerDiv)[[1]], main)) 

  xml_remove(xml_find_first(containerDiv, '//*[@id="header"]'))
  xml_remove(xml_find_first(containerDiv, '//*[@id="footer"]'))

  main <- xml_child(containerDiv)
  xml_attr(main, "class") <- "main col-sm-12"
  
  #xml_remove(xml_find_all(main, '//a[@aria-hidden="true"]'))
  xml_remove(xml_find_all(xml_find_all(main, '//*[@class="sourceCode"]'), './/a'))
  
  descrpt <- gsub(
    "(src=\"\\./figures|src=\"figures)", 
    "src=\"https://laustep.github.io/stlahblog/posts/figures",
    as.character(containerDiv)
  )
  #descrpt <- as.character(xml_find_first(read_html(descrpt), ".//div"))
  descrpt <- prettifyAddins::prettify_V8(descrpt, "html", tabSize = 2)
    
  x <- xml_new_root("description")
  xml_add_child(x, xml_cdata(descrpt))
  invisible(xml_replace(descriptions[[i]], xml_root(x)))
  
}

writeLines(as.character(feed), "feed_cleaned.xml", useBytes = TRUE)
