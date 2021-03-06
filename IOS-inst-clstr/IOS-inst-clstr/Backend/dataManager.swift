//
//  localbuffer.swift
//  IOS-inst-clstr
//
//  Created by Richard Wei on 11/8/20.
//

import Foundation
import UIKit
import Charts

class dataManager{
    //var startUnixEpoch : Double = -1;
    
    static let obj = dataManager();
    
    let unixEpochPrecision : Double = 1000;
    
    private init(){
        //startUnixEpoch = Date().timeIntervalSince1970;
        //print("Current UNIX EPOCH = \(startUnixEpoch)");
    }
    
    func updateWithNewData(data: APiDataPack){
        let currentUnixEpoch = Date().timeIntervalSince1970;
        //print("data recieved at - \(currentUnixEpoch)");
        
        //buffer.append(convertRawData(data: data, currentUnixEpoch: currentUnixEpoch));
        // call func to update ui
        let currentData = convertRawData(data: data, currentUnixEpoch: currentUnixEpoch);
        for i in 0..<graphs.numOfGraphs{
            // print("calling - \(i) - data - \(currentData[i])")
            if (!graphs.updateGraph(with: i, point: currentData[i])){
                print("Failed to add data point at graph with index \(i) : Timestamp = \(currentUnixEpoch)");
                errors.addErrorToBuffer(error: errorData(description: "Failed to add data point at graph with index \(i) : Timestamp = \(currentUnixEpoch)", timeStamp: errors.createTimestampStruct()));
            }
        }
        // TODO: call extra func here to mainview to update data that doesn't need a graph
        for i in 0..<mainViewClass.miscStatusLabels.count{
            let currentData = getMiscData(from: i, data: data);
            DispatchQueue.main.sync {
                if (i == 3){
                    mainViewClass.miscStatusLabels[i].text = currentData == 1 ? "Batteries" : "Solar Panels";
                    mainViewClass.miscStatusLabels[i].textColor = InverseBackgroundColor;
                }
                else{
                    let isOn = currentData == 1;
                    mainViewClass.miscStatusLabels[i].text = (isOn ? "ON" : "OFF");
                    mainViewClass.miscStatusLabels[i].textColor = (isOn ? UIColor.green : UIColor.red);
                }
            }
        }
        
    }
    
    private func getMiscData(from index: Int, data: APiDataPack) -> Int{
        switch index {
        case 0:
            return data.mddStatus ? 1 : 0;
        case 1:
            return data.ocpStatus ? 1 : 0;
        case 2:
            return data.ovpStatus ? 1 : 0;
        case 3:
            return data.psuMode;
        default:
            return -1;
        }
    }
  
    
    private func convertRawData(data: APiDataPack, currentUnixEpoch: Double)->[ChartDataEntry]{ // one [ChartDataEntry] is one recieved APiDataPack with (x: time, y: data point)
        // data point order is determined by graphName in graphManager
        let timeDiff = (Float64(Int(data.timeStamp * 1000)) / 1000);
        var output = Array(repeating: ChartDataEntry(), count: graphs.numOfGraphs);
        
        for i in 0..<graphs.numOfGraphs{
            output[i] = ChartDataEntry(x: timeDiff, y: Double(specificDataAttribute(with: i, data: data)));
        }
        
        return output;
    }
    
    // ["RPM", "Torque", "Throttle (%)", "Duty (%)", "PWM Frequency", "Temperature (C)", "Source Voltage", "PWM Current", "Power Change (Δ)", "Voltage Change (Δ)"];
    
    public func specificDataAttribute(with index: Int, data: APiDataPack) -> Float32{ // will convert ints to floats as well
        switch index{
        case 0:
            return data.rpm;
        case 1:
            return data.torque;
        case 2:
            return Float32(data.throttlePercent);
        case 3:
            return Float32(data.dutyPercent);
        case 4:
            return Float32(data.pwmFrequency);
        case 5:
            return Float32(data.tempC);
        case 6:
            return data.sourceVoltage;
        case 7:
            return data.pwmCurrent;
        case 8:
            return data.powerChange;
        case 9:
            return data.voltageChange;
        default:
            return 0;
        }
    }
    
    func clearData(){
        //buffer.removeAll();
    }
    
}
