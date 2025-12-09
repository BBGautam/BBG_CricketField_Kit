# 🏏 BBG_CricketField_Kit

BBG_CricketField_Kit is a lightweight, reusable Swift Package that provides a fully interactive cricket ground layout UI component for native iOS apps.  
It allows users to tap on field positions, visualize selection, and integrate custom logic easily.

---

## 📌 Features

- Fully interactive **Cricket Field View**
- Tap to select any fielding position
- Supports predefined cricket positions
- Customizable callbacks for selection
- Lightweight, SwiftUI-friendly structure
- iOS native (`UIKit`) implementation

---


🛠 Requirements
Requirement	Version
iOS	13.0+
Xcode	15+
Swift	5.7+

---

📦 Installation & Integration Guide
Step 1 — Add Package in Xcode

Open your Xcode project.

Go to:
File → Add Packages

In the search box, paste the package URL:

https://github.com/BBGautam/BBG_CricketField_Kit.git


Choose the dependency rule:

Up to Next Major Version

Select your app target.

Click Add Package.


Step 2 — Import the Framework

In any file where you want to use the field view:

import BBG_CricketField_Kit


Step 3 — Add Cricket Field View to Your Screen
let groundView = GroundLayoutView()
groundView.frame = CGRect(x: 0, y: 100, width: 300, height: 300)
view.addSubview(groundView)


let groundView = GroundLayoutView()
groundView.translatesAutoresizingMaskIntoConstraints = false
view.addSubview(groundView)

NSLayoutConstraint.activate([
    groundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    groundView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    groundView.widthAnchor.constraint(equalToConstant: 300),
    groundView.heightAnchor.constraint(equalToConstant: 300)
])


Step 4 — Handle Position Selection

groundView.onPositionSelect = { position in
    print("Selected Field Position: \(position.type.displayName())")
}

## 📷 Preview

>   
<img width="393" height="852" alt="IMG_0102" src="https://github.com/user-attachments/assets/45fdef74-b538-4f24-a2ed-f3c91a67b642" />
