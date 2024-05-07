import { defineConfig } from 'vitepress'

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: "minunit",
  description: "docs docs",
host:"0.0.0.0",
port:5174,

  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    nav: [
      { text: 'Home', link: '/' },

    ],


    sidebar: [
      {
        text: 'Examples',
        items: [

        ]
      }
    ],

    socialLinks: [
      { icon: 'github', link: 'https://github.com/SOPD' }
    ],
    footer: {
      message: '   最小单元技术站 豫ICP备20019657号-1  联系我：minunit@163.com',
      copyright:'  <span id="busuanzi_container_site_pv">访问量<span id="busuanzi_value_site_pv"></span>次</span> 全站文章除单独声明外，采用MIT许可协议  '
    }
    
  }
})
