//
//  ViewController.swift
//  TikTok
//
//  Created by TORVIS on 01/09/23.
//

import UIKit
import GSPlayer

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var videoData: [Transcoding] = []
    
    var videoURLsToPrefetch = [URL]()
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchJson()
        collectionView?.prefetchDataSource = self
        collectionView?.register(UINib(nibName: "VideosCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "VideosCollectionViewCell")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.isPagingEnabled = true
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    
    //MARK: Api Call
    func fetchJson() {
        fetchingJson { result in
            self.videoData = result
            print("\(result)")
            for video in 0..<self.videoData.count {
                self.videoURLsToPrefetch.append(URL(string:self.videoData[video].httpuri )!)
                VideoPreloadManager.shared.set(waiting: self.videoURLsToPrefetch)
            }
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
            self.collectionView.reloadData()
            
        }
    }
    
    //MARK: Api for fetching data from json
    func fetchingJson(handler: @escaping(_ result: [Transcoding]) -> Void) {
        guard let fileLocation = Bundle.main.url(forResource: "videos", withExtension: "json") else { return }
        
        do {
            let data = try Data(contentsOf: fileLocation)
            let json = try JSONSerialization.jsonObject(with: data)
            print(json)
            let decorder = try JSONDecoder().decode([VideoJsonModel].self, from: data)
            //handler call here
            handler(decorder[0].transcodings)
            print(decorder)
        } catch {
            print("parsing Error")
        }
    }
}
//MARK: CollectionView Delegate, DataSource and FlowLayoutDelegate

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print("Prefetch: \(indexPaths)")
        for indexPath in indexPaths {
            // Retrieve or dequeue the cell for the specified indexPath
            if let cell = collectionView.cellForItem(at: indexPath) as? VideosCollectionViewCell {
                let videos = URL(string: self.videoData[indexPath.row].httpuri )!
                // Do any prefetching or data preparation for the cell here
                cell.set(url: videos)
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideosCollectionViewCell", for: indexPath) as? VideosCollectionViewCell
        let videos = URL(string: self.videoData[indexPath.row].httpuri )!
        cell?.set(url: videos)
        return cell ?? UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let videoCell = cell as? VideosCollectionViewCell {
            videoCell.play()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let videoCell = cell as? VideosCollectionViewCell {
            videoCell.pause()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    
    
}
