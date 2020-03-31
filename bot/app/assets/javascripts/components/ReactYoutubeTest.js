import React, {Component} from 'react'
import Youtube from 'react-youtube'

class ReactYoutubeTest extends Component {
videoOnReady(event){
    const player= event.target
    console.log(player)
}
videoOnPlay(event){
  const player= event.target
  console.log(event.target.getCurrentTime())
}
render() {
 const opts = {
   height: '390',
   width: '640',
   playerVars: { // https://developers.google.com/youtube/player_parameters
     autoplay: 1
   }
 }
 const {videoId}=this.props
 return (
   <Youtube
     videoId={videoId}
     opts={opts}
     onReady={this.videoOnReady}
     onPlay={this.videoOnPlay}
   />
 );
}
}
export default ReactYoutubeTest;
