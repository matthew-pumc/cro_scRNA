library(tidyverse)
library(pheatmap)

exp <- readxl::read_xlsx('/Users/matthew/Documents/Nutstore/02_Transcriptome/Cro_scRNA_sync/transporter/transporter_0703.xlsx', 
                         sheet = "Sheet3")
anno_row <- as.data.frame(exp$Family)
rownames(anno_row) <- exp$FigureName
exp <- as.data.frame(exp[,c(2:11)])

rownames(exp) <- exp$FigureName
exp1 <- exp[-1] %>% 
  mutate(sum = rowSums(.))%>% 
  filter(sum >= 0.1)
pheatmap(exp1[,c(1:9)],
         scale = 'row',
         cellheight = 10,
         annotation_row = anno_row,
         # annotation_names_row = "Type",
         cluster_cols = F,
         filename = "../Figures/transporter177_gt0.1.pdf")

exp <- readxl::read_xlsx('/Users/matthew/Documents/Nutstore/02_Transcriptome/Cro_scRNA_sync/transporter/transporter_hot.xlsx', 
                         sheet = "Sheet1")
exp <- as.data.frame(exp[,c(1:10)])

rownames(exp) <- exp$FigureName
exp1 <- exp[-1] %>% 
  mutate(sum = rowSums(.))%>% 
  filter(sum >= 0.1)
pheatmap(exp1[,c(1:9)],
         scale = 'row',
         cellheight = 10,
         filename = "../Figures/transporter194_gt0.1.pdf")
