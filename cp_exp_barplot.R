library(tidyverse)

exp <- read.csv('/Users/matthew/Documents/scRNA/Cro_scRNA/02.Clustering/all.chl.exp.csv')
exp <- exp[,c(1:16)] 
exp_sum <- exp %>% 
  group_by(type) %>% 
  summarise_if(is.numeric, sum)

write.csv(exp_sum, file = 'chl_exp.sum.csv')

exp_clean <- read.csv('chl_exp.sum.clean.csv')

ggplot(exp_clean, aes(x = cluster, y = exp, fill = type)) +
  geom_bar(stat = "identity", width = 0.7) +
  # scale_fill_npg() +
  theme_classic() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5))

# ggsave('../plot_in_scratch/umi_deg_barplot.pdf', width = 8, height = 4)