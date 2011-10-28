//
//  mapViewController.m
//  nomimono
//
//  Created by JimLiao on 1ß1/10/7.
//  Copyright 2011年 jimliao@thlight.com All rights reserved.
//

#import "mapViewController.h"
#import "placePin.h"
#import "Sqlite.h"
#import "detailViewController.h"
#import "Animation.h"

@implementation mapViewController

@synthesize userProfileVC;

- (void)dealloc
{
    
    [myMap release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		mapViewController *MyViewCon = [[[mapViewController alloc]initWithNibName:@"mapViewController" bundle:nil]autorelease];
		
		UINavigationController *naviBar =[[[UINavigationController alloc]
										   initWithRootViewController:MyViewCon]autorelease];
		[MyViewCon.view addSubview:naviBar.view];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	
    [super viewDidLoad];
	//    UIApplication *app = [UIApplication sharedApplication];
	//    app.statusBarHidden = NO;
	
    self.title = @"地圖"; 
    Sqlite *sqlite= [[[Sqlite alloc] init] autorelease];
	
    myMap = [[MKMapView alloc]initWithFrame:
			 CGRectMake(0.0f, 0.0f, 320.0f, 480.0f)];
    //顯示目前使者位置
    
    //設定地圖顯示模式,環境
    myMap.mapType = MKMapTypeStandard;
    myMap.scrollEnabled = YES;
    myMap.zoomEnabled = YES;
    
    //將MapView顯示於畫面
    myMap.delegate = self;
    [self.view addSubview:myMap];
    [self nowOnLocation];
    [self mapView:myMap viewForAnnotation:NULL];
    sqlite.init;
	
}

//定義位置並設定大頭針
- (void)nowOnLocation {
    //取得現在位置
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate=self; 
    
    myMap.showsUserLocation = YES;//定位使用者位置
    
	
    //設定經緯度
    CLLocationCoordinate2D mapCenter;
	
	
    mapCenter.latitude = locationManager.location.coordinate.latitude;
    mapCenter.longitude = locationManager.location.coordinate.longitude;
    if (mapCenter.latitude) {
		mapCenter.latitude = locationManager.location.coordinate.latitude;
		mapCenter.longitude = locationManager.location.coordinate.longitude;
	} else {
		mapCenter.latitude = 25.045092  ;
		mapCenter.longitude = 121.513426  ;
		
	}
    //Map Zoom設定
    MKCoordinateSpan mapSpan;
    mapSpan.latitudeDelta = 0.01;
    mapSpan.longitudeDelta = 0.01;
    
    //設定地圖顯示位置
    MKCoordinateRegion mapRegion;
    mapRegion.center = mapCenter;
    mapRegion.span = mapSpan;
    
    //前往顯示位置
    [myMap setRegion:mapRegion];
    [myMap regionThatFits:mapRegion];
	
    //插大頭針
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
	
	Sqlite *sqlite= [[[Sqlite alloc] init] autorelease];
	
    double_t lat,lon;
    for (int i = 0; i <= 391; i++) { 
		
        lat =[[[sqlite.transferarray objectAtIndex:i]objectAtIndex:3]doubleValue];
		lon =[[[sqlite.transferarray objectAtIndex:i]objectAtIndex:4]doubleValue];
        //隨機設定標籤的緯度   
        CLLocationCoordinate2D pinCenter;   
        pinCenter.latitude = lat; 
        pinCenter.longitude = lon;  
        
        //建立一個地圖標籤並設定內文   
		placePin *annotation = [[placePin alloc]initWithCoordinate:pinCenter];   
        annotation.title = [[sqlite.transferarray objectAtIndex:i]objectAtIndex:0];   
        annotation.subtitle = [[sqlite.transferarray objectAtIndex:i]objectAtIndex:1]; 
        
        //將製作好的標籤放入陣列中        
        [annotations addObject:annotation];
		
    }    
    
    //將陣列中所有的標籤顯示在地圖上  
    [myMap addAnnotations:annotations];  
    [annotations release];
}

//建立MapPin時會呼叫的函式
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    //判斷Pin如果是目前位置就不修改
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    static NSString* AnnotationIdentifier = @"AnnotationIdentifier";
	MKPinAnnotationView *pinView = [[[MKPinAnnotationView alloc]
									 initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier] autorelease];
    
    //設定顏色
    //pinView.pinColor = MKPinAnnotationColorGreen;
    //設定向邊選項圖案
	//  UIImage *image = [UIImage imageNamed:@"Turkey.gif"];
	//  UIImageView  *imageView = [[UIImageView alloc] initWithImage:image];
	// [image release];
	
    //重設圖片大小與座標
	// imageView.frame = CGRectMake(0, 0, 30, 30);
    temp=(int)(arc4random() % 3);
    //重設大頭針圖案大小與座標
    if (temp==0) {
        pinView.image =[UIImage imageNamed:@"coffee.png"];
    }
    else if(temp==1)
    {
        pinView.image = [UIImage imageNamed:@"juice.png" ];
    }
    else
    {
        pinView.image = [UIImage imageNamed:@"milk.png" ];
    }
    
    //設定註解內的圖片
	// pinView.rightCalloutAccessoryView = imageView;
	
	//點擊時有動畫落下效果
	pinView.animatesDrop=YES;
	//點擊時是否出現註解
	pinView.canShowCallout=YES;
	
	UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	[rightButton setTitle:annotation.title forState:UIControlStateNormal];
	[rightButton addTarget:self
					action:@selector(showDetail:)
		  forControlEvents:UIControlEventTouchUpInside];
	pinView.rightCalloutAccessoryView = rightButton;
	
	//	UIImageView *profileIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile.png"]];
	//	[profileIconView for
	//	pinView.leftCalloutAccessoryView = profileIconView;
	
	// [imageView release];
    
	
    return pinView;
}

//Reveal Detail of store
-(IBAction)showDetail:(id)sender{
	
	userProfileVC = [[[detailViewController alloc]init] autorelease];
	
	NSLog(@"Annotation Click");
	self.userProfileVC.title=((UIButton *)sender).currentTitle;
	[self.navigationController pushViewController:self.userProfileVC animated:YES];
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
	
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
