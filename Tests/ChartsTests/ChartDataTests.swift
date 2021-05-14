//
//  ChartDataTests.swift
//  ChartsTests
//
//  Created by Peter Kaminski on 1/23/20.
//

@testable import Charts
import XCTest

class ChartDataTests: XCTestCase {
    var data: ScatterChartData!

    private enum SetLabels {
        static let one = "label1"
        static let two = "label2"
        static let three = "label3"
        static let badLabel = "Bad label"
    }

    override func setUp() {
        super.setUp()

        let setCount = 5
        let range: UInt32 = 32
        let values1 = (0 ..< setCount).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(range) + 3)
            return ChartDataEntry(x: Double(i), y: val)
        }
        let values2 = (0 ..< setCount).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(range) + 3)
            return ChartDataEntry(x: Double(i), y: val)
        }
        let values3 = (0 ..< setCount).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(range) + 3)
            return ChartDataEntry(x: Double(i), y: val)
        }

        let set1 = ScatterChartDataSet(entries: values1, label: SetLabels.one)
        let set2 = ScatterChartDataSet(entries: values2, label: SetLabels.two)
        let set3 = ScatterChartDataSet(entries: values3, label: SetLabels.three)

        data = ScatterChartData(dataSets: [set1, set2, set3])
    }

    func testGetDataSetByLabelCaseSensitive() {
        XCTAssertTrue(data.dataSet(forLabel: SetLabels.one, ignorecase: false)?.label == SetLabels.one)
        XCTAssertTrue(data.dataSet(forLabel: SetLabels.two, ignorecase: false)?.label == SetLabels.two)
        XCTAssertTrue(data.dataSet(forLabel: SetLabels.three, ignorecase: false)?.label == SetLabels.three)
        XCTAssertTrue(data.dataSet(forLabel: SetLabels.one.uppercased(), ignorecase: false) == nil)
    }

    func testGetDataSetByLabelIgnoreCase() {
        XCTAssertTrue(data.dataSet(forLabel: SetLabels.one, ignorecase: true)?.label == SetLabels.one)
        XCTAssertTrue(data.dataSet(forLabel: SetLabels.two, ignorecase: true)?.label == SetLabels.two)
        XCTAssertTrue(data.dataSet(forLabel: SetLabels.three, ignorecase: true)?.label == SetLabels.three)

        XCTAssertTrue(data.dataSet(forLabel: SetLabels.one.uppercased(), ignorecase: true)?.label == SetLabels.one)
        XCTAssertTrue(data.dataSet(forLabel: SetLabels.two.uppercased(), ignorecase: true)?.label == SetLabels.two)
        XCTAssertTrue(data.dataSet(forLabel: SetLabels.three.uppercased(), ignorecase: true)?.label == SetLabels.three)
    }

    func testGetDataSetByLabelNilWithBadLabel() {
        XCTAssertTrue(data.dataSet(forLabel: SetLabels.badLabel, ignorecase: true) == nil)
        XCTAssertTrue(data.dataSet(forLabel: SetLabels.badLabel, ignorecase: false) == nil)
    }

    func testXBoundsRange() {
        let dataset = ScatterChartDataSet(entries: [
            ChartDataEntry(x: 0.0, y: 2.0),
            ChartDataEntry(x: 1.0, y: 2.0),
            ChartDataEntry(x: 2.0, y: 2.0),
        ])

        let data = ScatterChartData(dataSet: dataset)

        let scatterView = ScatterChartView()
        scatterView.data = data
        scatterView.xAxis.axisMinimum = 0.0
        scatterView.xAxis.axisMaximum = 5.0

        let xrange = BarLineScatterCandleBubbleRenderer.XBounds(chart: scatterView, dataSet: dataset, animator: nil)
        print(xrange)
        XCTAssertTrue(xrange.min == 0)
        XCTAssertEqual(xrange.map { $0 }, [0, 1, 2])
    }

    func testXBoundsRangeOnEdge() {
        let dataset = ScatterChartDataSet(entries: [
            ChartDataEntry(x: 0.0, y: 2.0),
            ChartDataEntry(x: 1.0, y: 2.0),
            ChartDataEntry(x: 2.0, y: 2.0),
        ])

        let data = ScatterChartData(dataSet: dataset)

        let scatterView = ScatterChartView()
        scatterView.data = data
        scatterView.xAxis.axisMinimum = 2.0
        scatterView.xAxis.axisMaximum = 5.0

        let xrange = BarLineScatterCandleBubbleRenderer.XBounds(chart: scatterView, dataSet: dataset, animator: nil)
        XCTAssertTrue(xrange.min == 2)
        XCTAssertEqual(xrange.map { $0 }, [2])
    }
}
