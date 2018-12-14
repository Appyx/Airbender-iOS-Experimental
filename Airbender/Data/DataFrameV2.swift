//
//  DataframeV2.swift
//  Airbender
//
//  Created by Christopher Ebner on 14.12.18.
//  Copyright © 2018 FH Hagenberg. All rights reserved.
//

import Foundation

class DataFrameV2 {
    
    private var dimensions:[SampleFrame]=[]
    
    init(adapter:DataFrameAdapter) throws {
        let dim=adapter.getDimensions()
        self.init(dimensions: dim)
        try checkForMatchingDimensions()
    }
    
    /// checks if all dimensions contain the same amount of samples and if all samples contain the same amount of collumns
    func checkForPerfectCube() throws {
        var rowCounts: [Int] = []
        dimensions.forEach{
           rowCounts.append($0.samples.count)
        }
        var colCounts: [Int] = []
        dimensions.forEach{
             colCounts.append(contentsOf: $0.samples.map { $0.length })
        }
        
        func allEqual(arr: [Int]) -> Bool {
            return arr.allSatisfy { $0 == arr.first }
        }
        
        if allEqual(arr: rowCounts) && allEqual(arr: colCounts){
            return
        }
        throw DataFrameError.noPerfectCube
    }
    
    /// checks if both dataframes have the same amount of dimensions
    func checkDimensionCount(other: DataFrameV2) throws {
        if dimensions.count == other.dimensions.count {
            return
        }
        throw DataFrameError.dimensionCountMismatch
    }
    
    
    /// checks if each individual sample shares the same lengh with samples in other dimesions
    func checkForMatchingDimensions() throws{
        var lenghts=dimensions.map{$0.samples.map{$0.features.count}}
        func allEqual(arr: [[Int]]) -> Bool {
            return arr.allSatisfy { $0 == arr.first }
        }
        
        if allEqual(arr: lenghts){
            return
        }
        throw DataFrameError.dimensionsNotMatching
    }
    
    func featurelessCopy() -> DataFrameV2 {
        let new=DataFrameV2()
        for (_, element) in dimensions.enumerated(){
             new.dimensions.append(element.featurelessCopy())
        }
        return new
    }
    
    func copy() -> DataFrameV2 {
        let new=DataFrameV2()
        for (_, element) in dimensions.enumerated(){
            new.dimensions.append(element.copy())
        }
        return new
    }
    
    func applyInPlace(fun: ([Double]) -> [Double]) {
        dimensions.forEach{
            $0.applyInPlace(fun: fun)
        }
    }
    
    func apply(fun: ([Double]) -> [Double]) -> DataFrameV2 {
        let new=DataFrameV2()
        for (_, element) in dimensions.enumerated(){
            new.dimensions.append(element.apply(fun: fun))
        }
        return new
    }
    
    func append(other: DataFrameV2, fun: ([Double]) -> [Double]) {
         append(other.apply(fun: fun))
    }
    
    func append(other: DataFrameV2) throws{
        try checkDimensionCount(other)
        for (index, element) in dimensions.enumerated(){
            element.append(other: other.dimensions[index])
        }
    }
    
    func flatten() -> SampleFrame {
        let temp = dimensions[0].featurelessCopy()
        for (_, element) in dimensions.enumerated(){
            temp.append(other: element)
        }
        return temp
    }
    
    func applyFilter(fun: (Sample) -> Bool) {
        for (_, element) in dimensions.enumerated(){
            element.filter(fun: fun) //TODO: rename
        }
    }
    
    func applyWindow(size: Int, fun: ([Double]) -> Double) -> DataFrameV2 {
        let new = DataFrameV2()
        for (_, element) in dimensions.enumerated(){
            new.dimensions.append(other: element.slidingWindow(size: size, fun: fun))
        }
        return new
    }
    
    
}

enum DataFrameError:Error{
    case dimensionsNotMatching
    case noPerfectCube
    case dimensionCountMismatch
}

protocol DataFrameAdapter{
    func getDimensions()->[SampleFrame]
}
