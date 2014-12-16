BubbleControl-Swift
===================

a bubble control highly inspired from facebook chat heads.  
written in swift


Demo
----

![alt tag](https://github.com/cemolcay/BubbleControl-Swift/blob/master/demo.gif)  
  
  
Usage
-----

Copy & paste the BubbleControl.swift into your project
  
`init ` with `size` or `image`

        bubble = BubbleControl (size: CGSizeMake(80, 80))
  
        bubble = BubbleControl (image: UIImage (named: "image.png"))


set it content view (if you want to opens a content view)

      let contentView = UIView ()
      ....
      
      bubble.contentView = contentView
      
      

set content view open/close animations

      bubble.setOpenAnimation = { content, background in
          self.bubble.contentView!.bottom = win.bottom
          if (self.bubble.center.x > win.center.x) {
              self.bubble.contentView!.left = win.right
              self.bubble.contentView!.spring({ () -> Void in
                  self.bubble.contentView!.right = win.right
              }, completion: nil)
          } else {
              self.bubble.contentView!.right = win.left
              self.bubble.contentView!.spring({ () -> Void in
                  self.bubble.contentView!.left = win.left
              }, completion: nil)
          }
      

and other optional handlers

        var didToggle: ((Bool) -> ())?
        var didNavigationBarButtonPressed: (() -> ())?
        var didPop: (()->())?
        

Optional Values
---------------

        var snapsInside: Bool = false
        var popsToNavBar: Bool = true
        var movesBottom: Bool = false
        


