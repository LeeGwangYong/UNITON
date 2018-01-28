//
//  AWSPolly.swift
//  UNITON
//
//  Created by 이광용 on 2018. 1. 27..
//  Copyright © 2018년 이광용. All rights reserved.
//

import Foundation
import AVFoundation
import AWSPolly

struct AWSPolly_TTS{
    static let task = AWSPolly.default().describeVoices(AWSPollyDescribeVoicesInput())
    
    static func continueSpeach(audioPlayer: AVPlayer, text: String) {
        task.continueOnSuccessWith { (awsTask: AWSTask<AWSPollyDescribeVoicesOutput>) -> Any? in
            //            let data = (awsTask.result! as AWSPollyDescribeVoicesOutput).voices
            //            let sortedVoices = data!.sorted(by: { $0.languageName! < $1.languageName! })
            let input = AWSPollySynthesizeSpeechURLBuilderRequest()
            input.text = text
            input.outputFormat = AWSPollyOutputFormat.mp3
            input.voiceId = AWSPollyVoiceId.seoyeon
            
            let builder = AWSPollySynthesizeSpeechURLBuilder.default().getPreSignedURL(input)
            builder.continueOnSuccessWith(block: { (awsTask: AWSTask<NSURL>) -> Any? in
                let url = awsTask.result!
                
                audioPlayer.replaceCurrentItem(with: AVPlayerItem(url: url as URL))
                audioPlayer.play()
                return nil
            })
            
            return nil
        }
    }
}

