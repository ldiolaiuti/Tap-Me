//
//  ViewController.m
//  Tap Me
//
//  Created by Luca Diolaiuti on 13/02/15.
//  Copyright (c) 2015 Luca Diolaiuti. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (AVAudioPlayer *)setupAudioPlayerWithFile:(NSString *)file type:(NSString *)type{
    
    //Ottiene il path completo in cui si trovano i file. mainBundle indica dove cercare
    //AVAudioPlayer richiede il path in forma di URL
    NSString *path = [[NSBundle mainBundle] pathForResource:file ofType:type];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    //MEmorizza un messaggio di errore
    NSError *error;
    
    //Setup AudioPlayer
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    //In caso di errore mostra il messaggio
    if (!audioPlayer) {
        NSLog(@"%@",[error description]);
    }
    
    return audioPlayer;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_tile.png"]];
    scoreLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"field_score.png"]];
    timerLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"field_time.png"]];
    
    buttonBeep = [self setupAudioPlayerWithFile:@"ButtonTap" type:@"wav"];
    secondBeep = [self setupAudioPlayerWithFile:@"SecondBeep" type:@"wav"];
    backgroundMusic = [self setupAudioPlayerWithFile:@"HallOfTheMountainKing" type:@"mp3"];
    
    [self setupGame];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonPressed {
    count++;
    
    scoreLabel.text = [NSString stringWithFormat:@"Score\n%li", count];
    
    [buttonBeep play];
}


- (void)substractTime {
    //descrementa i secondi e aggiorna la label
    seconds--;
    timerLabel.text = [NSString stringWithFormat:@"Time: %li", seconds];
    
    [secondBeep play];
    
    //controlla se il timer è scaduto
    if (seconds==0){
        [timer invalidate];
        
        //Visualizza una finestra di popup
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tempo scaduto!"
                                                        message:[NSString stringWithFormat:@"Hai totalizzato %li punti", count]
                                                       delegate:self
                                              cancelButtonTitle:@"Gioca ancora!"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}


- (void)setupGame {
    //reset valori
    seconds = 30;
    count = 0;
    
    //reset Label
    timerLabel.text = [NSString stringWithFormat:@"Time: %li", seconds];
    scoreLabel.text = [NSString stringWithFormat:@"Score\n%li", count];
    
    //set timer
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                             target:self
                                           selector:@selector(substractTime)
                                           userInfo:nil
                                            repeats:YES];
    
    [backgroundMusic setVolume:0.3];
    [backgroundMusic play];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self setupGame];
}

@end
