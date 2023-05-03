//
//  Track.hpp
//  daw
//
//  Created by Andrew Holt on 1/1/23.
//

#ifndef Track_hpp
#define Track_hpp

#include <string>

class Track {
public:
    Track();
    ~Track();
    
    // SMR
    void solo();
    void unSolo();
    void mute();
    void unMute();
    void record();
    void unRecord();
private:
    std::string title = "";
    float* buffer;
    
    // SMR
    bool isSoloed = false;
    bool isMuted = false;
    bool isRecording = false;
};

#endif /* Track_hpp */
