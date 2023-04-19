//
//  Home.swift
//  SpotifyNewUI
//
//  Created by Giuseppe, De Masi on 23/03/22.
//

import SwiftUI

struct Home: View {
    
    @State var expandCard: Bool = false
    @State var currentCard: Album?
    //storing index to animate cards
    @State var currentIndex: Int = -1
    @State var showDetail: Bool = false
    //hero animation
    @Namespace var animation
    //current album image size
    @State var cardSize: CGSize = .zero
    //detail card animation properties
    @State var animateDetailView: Bool = false
    @State var rotateCard: Bool = false
    @State var showDetailContent: Bool = false
    //playlistbuttons animation
    @State var isStopped: Bool = false
    @State var isShuffled: Bool = false
    @State var isRandom: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Image("spotify_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35, height: 35)
                
                Spacer()
                
                HStack(spacing: 12) {
                    Button {
                        
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease")
                            .font(.title2)
                            .foregroundColor(Color("play"))
                    }

                    Button {
                        
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .font(.title2)
                            .foregroundColor(Color("play"))
                    }
                }
            }
            .overlay(
                Text("My Playlist")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            )
            .padding(.horizontal)
            
            GeometryReader { proxy in
                let size = proxy.size
                stackPlayerView(size: size)
                    .frame(width: size.width, height: size.height, alignment: .center)
            }
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Recently Played")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(albums) {album in
                            Button {
                                
                            } label: {
                                Image(album.albumImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 95, height: 95)
                                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                            }

                        }
                    }
                    .padding([.horizontal, .bottom])
                }
            }
        }
        .padding(.vertical)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color("bg").ignoresSafeArea())
        .overlay {
            if let currentCard = currentCard, showDetail {
                ZStack {
                    Color("bg")
                        .ignoresSafeArea()
                    
                    detailView(currentCard: currentCard)
                }
            }
        }
    }
    
    //stack playlist view
    @ViewBuilder
    func stackPlayerView(size: CGSize) -> some View {
        
        let offsetHeight = size.height * 0.1
        
        ZStack {
            ForEach(stackAlbums.reversed()) {album in
                
                let index = getAlbumIndex(album: album)
                let imageSize = (size.width - CGFloat(index) *  20)
                
                Image(album.albumImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: imageSize / 2, height: imageSize / 2)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                //3D rotation
                    .rotation3DEffect(.init(degrees: expandCard && currentIndex != index ? -10 : 0), axis: (x: 1, y: 0, z: 0), anchor: .center, anchorZ: 1, perspective: 1)
                    .rotation3DEffect(.init(degrees: showDetail && currentIndex == index && rotateCard ? 360 : 0), axis: (x: 1, y: 0, z: 0), anchor: .center, anchorZ: 1, perspective: 1)
                    .matchedGeometryEffect(id: album.id, in: animation)
                    .offset(y: CGFloat(index) * -20)
                    .offset(y: expandCard ? -CGFloat(index) * offsetHeight : 0)
                    .onTapGesture {
                        if expandCard {
                            //selecting card
                            withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 0.8, blendDuration: 0.8)) {
                                cardSize = CGSize(width: imageSize / 2, height: imageSize / 2)
                                currentCard = album
                                currentIndex = index
                                showDetail = true
                                rotateCard = true
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    withAnimation(.spring()) {
                                        animateDetailView = true
                                    }
                                }
                            }
                            
                        } else {
                            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                expandCard = true
                            }
                        }
                    }
                    .offset(y: showDetail && currentIndex != index ? size.height * (currentIndex < index ? -1 : 1) : 0)
            }
        }
        .offset(y: expandCard ? offsetHeight * 2 : 0)
        .frame(width: size.width, height: size.height)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                expandCard.toggle()
            }
        }
    }
    
    //detailView
    @ViewBuilder
    func detailView(currentCard: Album) -> some View {
        VStack(spacing: 0) {
            Button {
                rotateCard = false
                withAnimation {
                    showDetailContent = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 0.8, blendDuration: 0.8)) {
                        self.currentIndex = -1
                        self.currentCard = nil
                        showDetail = false
                        animateDetailView = false
                    }
                }
            } label: {
            Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(Color("play"))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding([.horizontal, .top])
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 25) {
                    Image(currentCard.albumImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: cardSize.width, height: cardSize.height)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .rotation3DEffect(.init(degrees: showDetail && rotateCard ? -180 : 0), axis: (x: 1, y: 0, z: 0), anchor: .center, anchorZ: 1, perspective: 1)
                        .rotation3DEffect(.init(degrees: animateDetailView && rotateCard ? 180 : 0), axis: (x: 1, y: 0, z: 0), anchor: .center, anchorZ: 1, perspective: 1)
                        .matchedGeometryEffect(id: currentCard.id, in: animation)
                        .padding(.top, 50)
                    
                    VStack(spacing: 20) {
                        Text(currentCard.albumName)
                            .font(.title.bold())
                            .foregroundColor(.white)
                            .padding(.top, 10)
                        
                        HStack(spacing: 50) {
                            Button {
                                withAnimation{
                                    isShuffled.toggle()
                                }
                            } label: {
                                Image(systemName: "shuffle")
                                    .font(.title2)
                                    .foregroundColor(isShuffled ? Color("play") : .white)
                            }

                            Button {
                                withAnimation {
                                    isStopped.toggle()
                                }
                            } label: {
                                Image(systemName:isStopped ? "play.fill" : "pause.fill")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color("play"), in: Circle())
                                    .shadow(radius: 5)
                            }
                            
                            Button {
                                withAnimation{
                                    isRandom.toggle()
                                }
                            } label: {
                                Image(systemName: "arrow.2.squarepath")
                                    .font(.title2)
                                    .foregroundColor(isRandom ? Color("play") : .white)
                            }
                        }
                        .padding(.top, 10)
                        
                        Text("Upcoming Song")
                            .font(.title3.bold())
                            .padding(.top, 20)
                            .padding(.bottom, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ForEach(albums){album in
                            albumCardView(album: album)
                        }
                    }
                    .padding(.horizontal)
                    .offset(y: showDetailContent ? 0 : 300)
                    .opacity(showDetailContent ? 1 : 0)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.easeInOut) {
                    showDetailContent = true
                }
            }
        }
    }
    
    //album card View
    @ViewBuilder
    func albumCardView(album: Album) -> some View {
        HStack(spacing: 12) {
            Image(album.albumImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 55, height: 55)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            
            VStack(alignment: .leading, spacing: 8) {
                Text(album.albumName)
                    .fontWeight(.semibold)
                
                Label {
                    Text(album.listeners)
                } icon: {
                    Image(systemName: "beats.headphones")
                }
                .font(.caption)
                .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                
            } label: {
                Image(systemName:album.isLiked ? "suit.heart.fill" : "suit.heart")
                    .font(.title3)
                    .foregroundColor(album.isLiked ? .pink : .secondary)
            }
            
            Button {
                
            } label: {
                Image(systemName: "ellipsis")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }

        }
    }
    
    func getAlbumIndex(album: Album) -> Int {
        return stackAlbums.firstIndex { currentAlbum in
            return album.id == currentAlbum.id
        } ?? 0
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
