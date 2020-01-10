//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

protocol DataEmptyHandler {
    var containerView: UIView! { get set }
    var empty_image: String { get }
    var empty_title: String { get }
    func emptyView() -> UIView
    func showEmptyView()
    func hideEmptyView()
}

extension DataEmptyHandler{
    // use a protocol extension to provide a default value or default func implementation
    var empty_image: String {
        return "test.png"
    }
    
    var empty_title: String {
        return "暂无数据"
    }
    
    func emptyView() -> UIView{
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20.0
        stackView.distribution = .fillProportionally
        let imageView = UIImageView(image: UIImage(named: empty_image))
        stackView.addArrangedSubview(imageView)
        let label = UILabel()
        label.text = empty_title
        label.textColor = .red
        label.textAlignment = .center
        stackView.addArrangedSubview(label)
        return stackView
    }
    
    func showEmptyView() {
        let ev = emptyView()
        ev.tag = 9527
        /*
         If you want to use Auto Layout to dynamically calculate the size and position of your view, you must set this property to false, and then provide a non ambiguous, nonconflicting set of constraints for the view.
         By default, the property is set to true for any view you programmatically create. If you add views in Interface Builder, the system automatically sets this property to false.
         */
        ev.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(ev)
        let centerX = NSLayoutConstraint(item: ev, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1.0, constant: 0)
        let centerY = NSLayoutConstraint(item: ev, attribute: .centerY, relatedBy: .equal, toItem: containerView, attribute: .centerY, multiplier: 1.0, constant: 0)
        /*
         When developing for iOS 8.0 or later, use the NSLayoutConstraint class’s activate(_:) method instead of calling the addConstraints(_:) method directly. The activate(_:) method automatically adds the constraints to the correct views.
         */
        NSLayoutConstraint.activate([centerX,centerY])
    }
    
    func hideEmptyView() {
        containerView.viewWithTag(9527)?.removeFromSuperview()
    }

}

class MyViewController : UIViewController,DataEmptyHandler {
    var data: [String] = []{didSet{dataDidChanged()}}
    var containerView: UIView!
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        let tv = UITableView(frame: view.bounds, style: .plain)
        tv.delegate = self
        tv.dataSource = self
        tv.tableFooterView = UIView()
        view.addSubview(tv)
        tableView = tv
        containerView = view
        data = []
    }
    
    func dataDidChanged() {
        tableView.reloadData()
        if data.count == 0 {
            showEmptyView()
        }else{
            hideEmptyView()
        }
    }
    
}

extension MyViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = data[indexPath.row]
        return cell!
    }
    
}


// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
