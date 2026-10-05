package com.smartfarm.smart_farm

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothClass
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCallback
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import android.bluetooth.BluetoothGattService
import android.bluetooth.BluetoothManager
import android.bluetooth.BluetoothProfile
import android.bluetooth.BluetoothSocket
import android.content.Context
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.OutputStream
import java.util.UUID

class MainActivity : FlutterActivity() {
    companion object {
        private const val CHANNEL = "com.smartfarm.smart_farm/native_bluetooth"
    }

    private var nativeGatt: BluetoothGatt? = null
    private var nativeWriteChar: BluetoothGattCharacteristic? = null
    private var isNativeBleConnected = false
    private var pendingConnectResult: MethodChannel.Result? = null
    private var pendingWriteResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getNativeBondedDevices" -> {
                    try {
                        val btManager = getSystemService(Context.BLUETOOTH_SERVICE) as? BluetoothManager
                        val adapter = btManager?.adapter ?: BluetoothAdapter.getDefaultAdapter()
                        if (adapter == null) {
                            result.success(emptyList<Map<String, Any?>>())
                            return@setMethodCallHandler
                        }

                        @Suppress("MissingPermission")
                        val bondedDevices = adapter.bondedDevices ?: emptySet()

                        val list = bondedDevices.map { device ->
                            val bondStr = when (device.bondState) {
                                BluetoothDevice.BOND_BONDED -> "BOND_BONDED (12)"
                                BluetoothDevice.BOND_BONDING -> "BOND_BONDING (11)"
                                else -> "BOND_NONE (10)"
                            }
                            
                            val typeInt = device.type
                            val typeStr = when (typeInt) {
                                BluetoothDevice.DEVICE_TYPE_UNKNOWN -> "0 = UNKNOWN"
                                BluetoothDevice.DEVICE_TYPE_CLASSIC -> "1 = CLASSIC"
                                BluetoothDevice.DEVICE_TYPE_LE -> "2 = LE"
                                BluetoothDevice.DEVICE_TYPE_DUAL -> "3 = DUAL"
                                else -> "$typeInt = UNKNOWN_VAL"
                            }

                            val btClass = device.bluetoothClass
                            val majorClass = btClass?.majorDeviceClass ?: -1
                            val devClass = btClass?.deviceClass ?: -1

                            val map = mutableMapOf<String, Any?>(
                                "address" to device.address,
                                "name" to device.name,
                                "typeInt" to typeInt,
                                "typeString" to typeStr,
                                "bondState" to bondStr,
                                "uuids" to (device.uuids?.map { it.uuid.toString() } ?: emptyList<String>()),
                                "bluetoothClass" to (btClass?.let { "0x${Integer.toHexString(it.deviceClass).uppercase()}" } ?: "NULL"),
                                "majorDeviceClass" to "0x${Integer.toHexString(majorClass).uppercase()} ($majorClass)",
                                "deviceClass" to "0x${Integer.toHexString(devClass).uppercase()} ($devClass)"
                            )
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                                map["alias"] = device.alias
                            }
                            map
                        }
                        result.success(list)
                    } catch (e: Exception) {
                        result.error("NATIVE_BT_ERROR", e.message, null)
                    }
                }

                "runAllBondedDiagnostics" -> {
                    Thread {
                        runAllBondedDevicesDiagnostics(result)
                    }.start()
                }

                "testHc05BleUart" -> {
                    val address = call.argument<String>("address") ?: "4D:50:04:EE:89:AA"
                    Thread {
                        testHc05BleUart(address, result)
                    }.start()
                }

                "testHc05BleGatt" -> {
                    val address = call.argument<String>("address") ?: "4D:50:04:EE:89:AA"
                    Thread {
                        testHc05BleGatt(address, result)
                    }.start()
                }

                "nativeConnect" -> {
                    val address = call.argument<String>("address")
                    if (address == null) {
                        result.error("INVALID_ADDRESS", "Address is required", null)
                        return@setMethodCallHandler
                    }
                    connectNativeDevice(address, result)
                }

                "nativeWrite" -> {
                    val data = call.argument<String>("data")
                    if (data == null) {
                        result.error("INVALID_DATA", "Data string required", null)
                        return@setMethodCallHandler
                    }
                    writeNativeDevice(data, result)
                }

                "nativeDisconnect" -> {
                    disconnectNativeDevice()
                    result.success(true)
                }

                else -> result.notImplemented()
            }
        }
    }

    @Suppress("MissingPermission")
    private fun runAllBondedDevicesDiagnostics(result: MethodChannel.Result) {
        println("==================================================")
        println("=== ALL BONDED BLUETOOTH DEVICES DIAGNOSTIC ===")

        val btManager = getSystemService(Context.BLUETOOTH_SERVICE) as? BluetoothManager
        val adapter = btManager?.adapter ?: BluetoothAdapter.getDefaultAdapter()

        if (adapter == null || !adapter.isEnabled) {
            println("Error: Bluetooth adapter is OFF or NULL")
            println("==================================================")
            runOnUiThread {
                result.success(mapOf("success" to false, "log" to "Bluetooth is OFF or NULL"))
            }
            return
        }

        val bondedDevices = adapter.bondedDevices ?: emptySet()
        println("Total Bonded Devices: ${bondedDevices.size}")

        val sb = StringBuilder()
        sb.append("=== ALL BONDED DEVICES METADATA ===\n\n")

        for ((idx, device) in bondedDevices.withIndex()) {
            val name = device.name ?: "Unknown"
            val address = device.address
            val bondInt = device.bondState
            val bondStr = when (bondInt) {
                BluetoothDevice.BOND_BONDED -> "BOND_BONDED ($bondInt)"
                BluetoothDevice.BOND_BONDING -> "BOND_BONDING ($bondInt)"
                else -> "BOND_NONE ($bondInt)"
            }

            val typeInt = device.type
            val typeMapped = when (typeInt) {
                BluetoothDevice.DEVICE_TYPE_UNKNOWN -> "0 = UNKNOWN"
                BluetoothDevice.DEVICE_TYPE_CLASSIC -> "1 = CLASSIC"
                BluetoothDevice.DEVICE_TYPE_LE -> "2 = LE"
                BluetoothDevice.DEVICE_TYPE_DUAL -> "3 = DUAL"
                else -> "$typeInt = UNKNOWN_VAL"
            }

            val uuidsList = device.uuids?.map { it.uuid.toString() } ?: emptyList()
            val btClass = device.bluetoothClass
            val majorClassInt = btClass?.majorDeviceClass ?: -1
            val deviceClassInt = btClass?.deviceClass ?: -1

            val majorHex = if (majorClassInt != -1) "0x${Integer.toHexString(majorClassInt).uppercase()}" else "NULL"
            val devHex = if (deviceClassInt != -1) "0x${Integer.toHexString(deviceClassInt).uppercase()}" else "NULL"

            println("Device [$idx]:")
            println("  Name: $name")
            println("  Address: $address")
            println("  Bond State: $bondStr")
            println("  Type: $typeInt -> $typeMapped")
            println("  UUIDs: $uuidsList")
            println("  BluetoothClass: ${btClass?.toString() ?: "NULL"} (DeviceClass: $devHex, MajorClass: $majorHex)")
            println("--------------------------------------------------")

            sb.append("Device #${idx + 1}: $name\n")
            sb.append("  MAC: $address\n")
            sb.append("  Bond State: $bondStr\n")
            sb.append("  Type (Int): $typeInt -> $typeMapped\n")
            sb.append("  Cached UUIDs: $uuidsList\n")
            sb.append("  BluetoothClass: ${btClass?.toString() ?: "NULL"}\n")
            sb.append("  Major Device Class: $majorHex ($majorClassInt)\n")
            sb.append("  Device Class: $devHex ($deviceClassInt)\n\n")
        }

        println("==================================================")
        val finalLog = sb.toString()
        runOnUiThread {
            result.success(mapOf("success" to true, "log" to finalLog))
        }
    }

    @Suppress("MissingPermission")
    private fun testHc05BleUart(targetAddress: String, result: MethodChannel.Result) {
        println("==================================================")
        println("=== HC-05 BLE UART DIAGNOSTIC INITIALIZED ===")

        val btManager = getSystemService(Context.BLUETOOTH_SERVICE) as? BluetoothManager
        val adapter = btManager?.adapter ?: BluetoothAdapter.getDefaultAdapter()

        if (adapter == null || !adapter.isEnabled) {
            println("Error: Bluetooth adapter is OFF or NULL")
            println("==================================================")
            runOnUiThread {
                result.success(mapOf("success" to false, "resultLog" to "Bluetooth is OFF or NULL"))
            }
            return
        }

        disconnectNativeDevice()

        val device: BluetoothDevice? = try {
            adapter.getRemoteDevice(targetAddress)
        } catch (e: Exception) {
            null
        }

        if (device == null) {
            println("Error: Device $targetAddress not found")
            println("==================================================")
            runOnUiThread {
                result.success(mapOf("success" to false, "resultLog" to "Device $targetAddress not found"))
            }
            return
        }

        val logSb = StringBuilder()
        logSb.append("=== HC-05 BLE UART DIAGNOSTIC ===\n")
        logSb.append("Device: ${device.name ?: "Unknown"}\n")
        logSb.append("MAC: ${device.address}\n")
        logSb.append("Bond State: ${device.bondState}\n")
        logSb.append("Type: ${device.type}\n\n")

        var bluetoothGatt: BluetoothGatt? = null
        var isFinished = false
        var ffe1Characteristic: BluetoothGattCharacteristic? = null
        var writeStep = 0

        fun returnResult(success: Boolean, message: String) {
            if (isFinished) return
            isFinished = true

            try {
                bluetoothGatt?.disconnect()
                bluetoothGatt?.close()
                println("BLE GATT closed cleanly.")
            } catch (e: Exception) {
                println("Error closing GATT: ${e.message}")
            }

            logSb.append(message)
            val outputLog = logSb.toString()
            println("==================================================")
            println(outputLog)
            println("==================================================")

            runOnUiThread {
                result.success(mapOf(
                    "success" to success,
                    "resultLog" to outputLog
                ))
            }
        }

        fun sendCharWrite(gatt: BluetoothGatt, char: BluetoothGattCharacteristic, value: ByteArray): String {
            return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                val statusInt = gatt.writeCharacteristic(char, value, BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT)
                "writeCharacteristic API 33+ returned status code: $statusInt (${if (statusInt == 0) "SUCCESS" else "ERR_$statusInt"})"
            } else {
                @Suppress("DEPRECATION")
                char.value = value
                @Suppress("DEPRECATION")
                char.writeType = BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT
                @Suppress("DEPRECATION")
                val successBool = gatt.writeCharacteristic(char)
                "writeCharacteristic legacy returned boolean: $successBool"
            }
        }

        val gattCallback = object : BluetoothGattCallback() {
            override fun onConnectionStateChange(gatt: BluetoothGatt, status: Int, newState: Int) {
                println("BLE onConnectionStateChange: status=$status, newState=$newState")
                if (status == BluetoothGatt.GATT_SUCCESS && newState == BluetoothProfile.STATE_CONNECTED) {
                    logSb.append("1. connectGatt(): STATE_CONNECTED (Status 0)\n")
                    logSb.append("2. Starting discoverServices()...\n")
                    val started = gatt.discoverServices()
                    if (!started) {
                        returnResult(false, "Failed to initiate GATT discoverServices()\n")
                    }
                } else if (newState == BluetoothProfile.STATE_DISCONNECTED) {
                    if (!isFinished) {
                        returnResult(false, "GATT Disconnected with status code: $status\n")
                    }
                } else {
                    if (!isFinished) {
                        returnResult(false, "GATT State Error: status=$status, newState=$newState\n")
                    }
                }
            }

            override fun onServicesDiscovered(gatt: BluetoothGatt, status: Int) {
                println("BLE onServicesDiscovered: status=$status")
                if (status != BluetoothGatt.GATT_SUCCESS) {
                    returnResult(false, "GATT discoverServices failed with status: $status\n")
                    return
                }

                logSb.append("3. discoverServices(): SUCCESS (Status 0)\n")

                val serviceUuid = UUID.fromString("0000FFE0-0000-1000-8000-00805F9B34FB")
                val service = gatt.getService(serviceUuid)
                if (service == null) {
                    returnResult(false, "4. Service FFE0 (0000FFE0-0000-1000-8000-00805F9B34FB) NOT FOUND!\n")
                    return
                }
                logSb.append("4. Located Service FFE0: ${service.uuid}\n")

                val ffe1Uuid = UUID.fromString("0000FFE1-0000-1000-8000-00805F9B34FB")
                val charFfe1 = service.getCharacteristic(ffe1Uuid)
                if (charFfe1 == null) {
                    returnResult(false, "5. Characteristic FFE1 (0000FFE1-0000-1000-8000-00805F9B34FB) NOT FOUND!\n")
                    return
                }
                ffe1Characteristic = charFfe1
                logSb.append("5. Located Characteristic FFE1: ${charFfe1.uuid}\n")

                val notifEnabled = gatt.setCharacteristicNotification(charFfe1, true)
                logSb.append("6. setCharacteristicNotification(FFE1, true): $notifEnabled\n")

                val cccdUuid = UUID.fromString("00002902-0000-1000-8000-00805F9B34FB")
                val cccdDescriptor = charFfe1.getDescriptor(cccdUuid)
                if (cccdDescriptor == null) {
                    returnResult(false, "7. CCCD descriptor (00002902-0000-1000-8000-00805F9B34FB) NOT FOUND!\n")
                    return
                }
                logSb.append("7. Located CCCD Descriptor: ${cccdDescriptor.uuid}\n")

                val enableValue = BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE
                val descWriteResultStr = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    val retCode = gatt.writeDescriptor(cccdDescriptor, enableValue)
                    "writeDescriptor API 33+ returned status code: $retCode (${if (retCode == 0) "SUCCESS" else "ERR_$retCode"})"
                } else {
                    @Suppress("DEPRECATION")
                    cccdDescriptor.value = enableValue
                    @Suppress("DEPRECATION")
                    val retBool = gatt.writeDescriptor(cccdDescriptor)
                    "writeDescriptor legacy returned boolean: $retBool"
                }
                logSb.append("8. Write CCCD enable notification value: $descWriteResultStr\n")
                logSb.append("9. Waiting for onDescriptorWrite completion...\n")
            }

            override fun onDescriptorWrite(gatt: BluetoothGatt, descriptor: BluetoothGattDescriptor, status: Int) {
                println("BLE onDescriptorWrite: status=$status, desc=${descriptor.uuid}")
                logSb.append("9. onDescriptorWrite completion: status=$status (${if (status == 0) "GATT_SUCCESS" else "FAIL"})\n")

                if (status != BluetoothGatt.GATT_SUCCESS) {
                    returnResult(false, "Descriptor write failed with status: $status\n")
                    return
                }

                val charFfe1 = ffe1Characteristic
                if (charFfe1 == null) {
                    returnResult(false, "Characteristic FFE1 is null in onDescriptorWrite\n")
                    return
                }

                writeStep = 1
                val write1Status = sendCharWrite(gatt, charFfe1, byteArrayOf('1'.code.toByte()))
                logSb.append("10. Write ASCII '1' (0x31) to FFE1: $write1Status\n")
                logSb.append("11. Waiting for onCharacteristicWrite for '1'...\n")
            }

            override fun onCharacteristicWrite(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, status: Int) {
                println("BLE onCharacteristicWrite: status=$status, char=${characteristic.uuid}, step=$writeStep")
                if (writeStep == 1) {
                    logSb.append("11. Write ASCII '1' Result: status=$status (${if (status == 0) "GATT_SUCCESS" else "FAIL"})\n")
                    logSb.append("12. Waiting 1000 ms before writing '0'...\n")
                    writeStep = 2

                    Thread {
                        try { Thread.sleep(1000) } catch (_: Exception) {}
                        val charFfe1 = ffe1Characteristic
                        if (charFfe1 != null && !isFinished) {
                            val write0Status = sendCharWrite(gatt, charFfe1, byteArrayOf('0'.code.toByte()))
                            logSb.append("13. Write ASCII '0' (0x30) to FFE1: $write0Status\n")
                            logSb.append("14. Waiting for onCharacteristicWrite for '0'...\n")
                        }
                    }.start()
                } else if (writeStep == 2) {
                    logSb.append("14. Write ASCII '0' Result: status=$status (${if (status == 0) "GATT_SUCCESS" else "FAIL"})\n")
                    logSb.append("15. Waiting 1000 ms for notifications / cleanup...\n")
                    writeStep = 3

                    Thread {
                        try { Thread.sleep(1000) } catch (_: Exception) {}
                        if (!isFinished) {
                            logSb.append("16. Disconnecting and closing GATT...\n")
                            returnResult(true, "\n=== BLE UART TEST COMPLETED SUCCESSFULLY ===\n")
                        }
                    }.start()
                }
            }

            @Deprecated("Deprecated in Java")
            override fun onCharacteristicChanged(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic) {
                @Suppress("DEPRECATION")
                val bytes = characteristic.value ?: byteArrayOf()
                val hexStr = bytes.joinToString(" ") { "0x%02X".format(it) }
                val asciiStr = String(bytes, Charsets.UTF_8).replace("\r", "\\r").replace("\n", "\\n")
                logSb.append("15. ON_CHARACTERISTIC_CHANGED (Legacy) [${characteristic.uuid}]:\n    HEX: $hexStr\n    ASCII: '$asciiStr'\n")
                println("BLE Notification: $asciiStr ($hexStr)")
            }

            override fun onCharacteristicChanged(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, value: ByteArray) {
                val hexStr = value.joinToString(" ") { "0x%02X".format(it) }
                val asciiStr = String(value, Charsets.UTF_8).replace("\r", "\\r").replace("\n", "\\n")
                logSb.append("15. ON_CHARACTERISTIC_CHANGED (API 33+) [${characteristic.uuid}]:\n    HEX: $hexStr\n    ASCII: '$asciiStr'\n")
                println("BLE Notification: $asciiStr ($hexStr)")
            }
        }

        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                bluetoothGatt = device.connectGatt(this, false, gattCallback, BluetoothDevice.TRANSPORT_LE)
            } else {
                bluetoothGatt = device.connectGatt(this, false, gattCallback)
            }
        } catch (e: Exception) {
            returnResult(false, "connectGatt Exception: ${e.javaClass.name}: ${e.message}\n")
        }

        Thread {
            try { Thread.sleep(15000) } catch (_: Exception) {}
            if (!isFinished) {
                returnResult(false, "GATT BLE UART test timed out after 15 seconds\n")
            }
        }.start()
    }

    @Suppress("MissingPermission")
    private fun testHc05BleGatt(targetAddress: String, result: MethodChannel.Result) {
        println("==================================================")
        println("=== HC-05 BLE GATT DIAGNOSTIC INITIALIZED ===")

        val btManager = getSystemService(Context.BLUETOOTH_SERVICE) as? BluetoothManager
        val adapter = btManager?.adapter ?: BluetoothAdapter.getDefaultAdapter()

        if (adapter == null || !adapter.isEnabled) {
            println("Error: Bluetooth adapter is OFF or NULL")
            println("==================================================")
            runOnUiThread {
                result.success(mapOf("success" to false, "resultLog" to "Bluetooth is OFF or NULL"))
            }
            return
        }

        // Close any prior native RFCOMM socket
        disconnectNativeDevice()

        val device: BluetoothDevice? = try {
            adapter.getRemoteDevice(targetAddress)
        } catch (e: Exception) {
            null
        }

        if (device == null) {
            println("Error: Device $targetAddress not found")
            println("==================================================")
            runOnUiThread {
                result.success(mapOf("success" to false, "resultLog" to "Device $targetAddress not found"))
            }
            return
        }

        val logSb = StringBuilder()
        logSb.append("=== HC-05 BLE GATT DIAGNOSTIC ===\n")
        logSb.append("Device: ${device.name ?: "Unknown"}\n")
        logSb.append("MAC: ${device.address}\n")
        logSb.append("Bond State: ${device.bondState}\n")
        logSb.append("Type: ${device.type} (2=LE, 3=DUAL)\n")
        logSb.append("Connecting via connectGatt(context, false)...\n\n")

        var bluetoothGatt: BluetoothGatt? = null
        var isResultReturned = false

        fun returnResult(success: Boolean, message: String) {
            if (isResultReturned) return
            isResultReturned = true

            try {
                bluetoothGatt?.disconnect()
                bluetoothGatt?.close()
                println("BLE GATT closed cleanly.")
            } catch (e: Exception) {
                println("Error closing GATT: ${e.message}")
            }

            logSb.append(message)
            val outputLog = logSb.toString()
            println("==================================================")
            println(outputLog)
            println("==================================================")

            runOnUiThread {
                result.success(mapOf(
                    "success" to success,
                    "resultLog" to outputLog
                ))
            }
        }

        val gattCallback = object : BluetoothGattCallback() {
            override fun onConnectionStateChange(gatt: BluetoothGatt, status: Int, newState: Int) {
                println("BLE onConnectionStateChange: status=$status, newState=$newState")
                if (status == BluetoothGatt.GATT_SUCCESS && newState == BluetoothProfile.STATE_CONNECTED) {
                    logSb.append("GATT Connection State: CONNECTED (Status 0)\n")
                    logSb.append("Starting discoverServices()...\n\n")
                    println("Connected to GATT server. Starting discoverServices()...")
                    val started = gatt.discoverServices()
                    if (!started) {
                        returnResult(false, "Failed to initiate GATT discoverServices()\n")
                    }
                } else if (newState == BluetoothProfile.STATE_DISCONNECTED) {
                    if (!isResultReturned) {
                        returnResult(false, "GATT Disconnected with status code: $status\n")
                    }
                } else {
                    if (!isResultReturned) {
                        returnResult(false, "GATT State Error: status=$status, newState=$newState\n")
                    }
                }
            }

            override fun onServicesDiscovered(gatt: BluetoothGatt, status: Int) {
                println("BLE onServicesDiscovered: status=$status")
                if (status == BluetoothGatt.GATT_SUCCESS) {
                    val services = gatt.services ?: emptyList()
                    logSb.append("=== DISCOVERED GATT SERVICES (${services.size}) ===\n\n")

                    for ((sIdx, service) in services.withIndex()) {
                        val sTypeStr = if (service.type == BluetoothGattService.SERVICE_TYPE_PRIMARY) "PRIMARY" else "SECONDARY"
                        logSb.append("Service #${sIdx + 1}:\n")
                        logSb.append("  UUID: ${service.uuid}\n")
                        logSb.append("  Type: $sTypeStr\n")

                        val characteristics = service.characteristics ?: emptyList()
                        logSb.append("  Characteristics (${characteristics.size}):\n")

                        for ((cIdx, char) in characteristics.withIndex()) {
                            val props = char.properties
                            val capsList = mutableListOf<String>()
                            if ((props and BluetoothGattCharacteristic.PROPERTY_READ) != 0) capsList.add("PROPERTY_READ")
                            if ((props and BluetoothGattCharacteristic.PROPERTY_WRITE) != 0) capsList.add("PROPERTY_WRITE")
                            if ((props and BluetoothGattCharacteristic.PROPERTY_WRITE_NO_RESPONSE) != 0) capsList.add("PROPERTY_WRITE_NO_RESPONSE")
                            if ((props and BluetoothGattCharacteristic.PROPERTY_NOTIFY) != 0) capsList.add("PROPERTY_NOTIFY")
                            if ((props and BluetoothGattCharacteristic.PROPERTY_INDICATE) != 0) capsList.add("PROPERTY_INDICATE")

                            logSb.append("    Char #${cIdx + 1}:\n")
                            logSb.append("      UUID: ${char.uuid}\n")
                            logSb.append("      Properties Raw: 0x${Integer.toHexString(props).uppercase()} ($props)\n")
                            logSb.append("      Capabilities: [${capsList.joinToString(", ")}]\n")

                            val descriptors = char.descriptors ?: emptyList()
                            if (descriptors.isNotEmpty()) {
                                logSb.append("      Descriptors (${descriptors.size}):\n")
                                for (desc in descriptors) {
                                    logSb.append("        - Desc UUID: ${desc.uuid}\n")
                                }
                            }
                            logSb.append("\n")
                        }
                    }
                    returnResult(true, "=== GATT DISCOVERY COMPLETE ===\n")
                } else {
                    returnResult(false, "GATT onServicesDiscovered failed with status: $status\n")
                }
            }
        }

        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                bluetoothGatt = device.connectGatt(this, false, gattCallback, BluetoothDevice.TRANSPORT_LE)
            } else {
                bluetoothGatt = device.connectGatt(this, false, gattCallback)
            }
        } catch (e: Exception) {
            returnResult(false, "connectGatt Exception: ${e.javaClass.name}: ${e.message}\n")
        }

        // Timeout fallback after 15 seconds
        Thread {
            try { Thread.sleep(15000) } catch (_: Exception) {}
            if (!isResultReturned) {
                returnResult(false, "GATT Connection/Discovery timed out after 15 seconds\n")
            }
        }.start()
    }

    @Suppress("MissingPermission")
    private fun connectNativeDevice(address: String, result: MethodChannel.Result) {
        println("[BLE CONNECT] Native connectNativeDevice called with address: $address")
        disconnectNativeDevice()

        val btManager = getSystemService(Context.BLUETOOTH_SERVICE) as? BluetoothManager
        val adapter = btManager?.adapter ?: BluetoothAdapter.getDefaultAdapter()
        if (adapter == null || !adapter.isEnabled) {
            println("[BLE CONNECT] Error: Bluetooth adapter is OFF or NULL")
            runOnUiThread {
                result.success(mapOf("isConnected" to false, "error" to "Bluetooth adapter is OFF or NULL"))
            }
            return
        }

        if (adapter.isDiscovering) {
            println("[BLE CONNECT] Cancelling active discovery before persistent BLE connection...")
            adapter.cancelDiscovery()
        }
        try { Thread.sleep(300) } catch (_: Exception) {}

        val device: BluetoothDevice? = try {
            adapter.getRemoteDevice(address)
        } catch (e: Exception) {
            null
        }

        if (device == null) {
            println("[BLE CONNECT] Error: Device not found for address $address")
            runOnUiThread {
                result.success(mapOf("isConnected" to false, "error" to "Device not found: $address"))
            }
            return
        }

        println("[BLE CONNECT] Calling native connectNativeDevice")
        println("[BLE CONNECT] Native connectGatt started for ${device.name ?: "HC-05"} ($address)")

        pendingConnectResult = result

        val serviceUuid = UUID.fromString("0000FFE0-0000-1000-8000-00805F9B34FB")
        val charUuid = UUID.fromString("0000FFE1-0000-1000-8000-00805F9B34FB")
        val cccdUuid = UUID.fromString("00002902-0000-1000-8000-00805F9B34FB")

        val gattCallback = object : BluetoothGattCallback() {
            override fun onConnectionStateChange(gatt: BluetoothGatt, status: Int, newState: Int) {
                println("[BLE CONNECT] onConnectionStateChange: status=$status, newState=$newState")
                if (status == BluetoothGatt.GATT_SUCCESS && newState == BluetoothProfile.STATE_CONNECTED) {
                    println("[BLE CONNECT] STATE_CONNECTED")
                    println("[BLE CONNECT] discoverServices")
                    val started = gatt.discoverServices()
                    if (!started) {
                        println("[BLE CONNECT] Error: Failed to initiate GATT discoverServices()")
                        finishNativeConnect(false, "Failed to initiate GATT discoverServices()")
                    }
                } else if (newState == BluetoothProfile.STATE_DISCONNECTED) {
                    println("[BLE CONNECT] BLE GATT Disconnected. Status: $status")
                    isNativeBleConnected = false
                    try {
                        gatt.disconnect()
                        gatt.close()
                    } catch (_: Exception) {}
                    nativeGatt = null
                    nativeWriteChar = null

                    runOnUiThread {
                        try {
                            flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
                                MethodChannel(messenger, CHANNEL).invokeMethod("onNativeDisconnected", mapOf("status" to status))
                            }
                        } catch (e: Exception) {
                            println("[BLE CONNECT] Failed to send onNativeDisconnected: ${e.message}")
                        }
                    }

                    if (pendingConnectResult != null) {
                        finishNativeConnect(false, "GATT Disconnected with status code: $status")
                    }
                } else {
                    println("[BLE CONNECT] GATT Connection state error: status=$status, newState=$newState")
                    if (pendingConnectResult != null) {
                        finishNativeConnect(false, "GATT Connection state error: status=$status, newState=$newState")
                    }
                }
            }

            override fun onServicesDiscovered(gatt: BluetoothGatt, status: Int) {
                println("[BLE CONNECT] onServicesDiscovered: status=$status")
                if (status != BluetoothGatt.GATT_SUCCESS) {
                    println("[BLE CONNECT] Error: GATT discoverServices failed with status $status")
                    finishNativeConnect(false, "GATT discoverServices failed with status: $status")
                    return
                }

                val service = gatt.getService(serviceUuid)
                if (service == null) {
                    println("[BLE CONNECT] Error: Service FFE0 (0000FFE0-0000-1000-8000-00805F9B34FB) NOT found")
                    finishNativeConnect(false, "Service FFE0 (0000FFE0-0000-1000-8000-00805F9B34FB) not found")
                    return
                }
                println("[BLE CONNECT] FFE0 found")

                val ffe1Char = service.getCharacteristic(charUuid)
                if (ffe1Char == null) {
                    println("[BLE CONNECT] Error: Characteristic FFE1 (0000FFE1-0000-1000-8000-00805F9B34FB) NOT found")
                    finishNativeConnect(false, "Characteristic FFE1 (0000FFE1-0000-1000-8000-00805F9B34FB) not found")
                    return
                }
                println("[BLE CONNECT] FFE1 found")

                nativeGatt = gatt
                nativeWriteChar = ffe1Char
                isNativeBleConnected = true

                // Setup notifications & CCCD
                try {
                    gatt.setCharacteristicNotification(ffe1Char, true)
                    val cccd = ffe1Char.getDescriptor(cccdUuid)
                    if (cccd != null) {
                        val enableVal = BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                            gatt.writeDescriptor(cccd, enableVal)
                        } else {
                            @Suppress("DEPRECATION")
                            cccd.value = enableVal
                            @Suppress("DEPRECATION")
                            gatt.writeDescriptor(cccd)
                        }
                    }
                } catch (e: Exception) {
                    println("[BLE CONNECT] Notification setup error (non-fatal): ${e.message}")
                }

                println("[BLE CONNECT] Persistent BLE connection READY")
                finishNativeConnect(true, null)
            }

            override fun onCharacteristicWrite(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, status: Int) {
                println("[BLE WRITE] onCharacteristicWrite: status=$status, char=${characteristic.uuid}")
                val res = pendingWriteResult
                pendingWriteResult = null
                if (res != null) {
                    runOnUiThread {
                        res.success(status == BluetoothGatt.GATT_SUCCESS)
                    }
                }
            }

            @Deprecated("Deprecated in Java")
            override fun onCharacteristicChanged(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic) {
                @Suppress("DEPRECATION")
                val bytes = characteristic.value ?: byteArrayOf()
                val asciiStr = String(bytes, Charsets.UTF_8)
                println("[BLE NOTIFICATION] Received (Legacy): $asciiStr")
            }

            override fun onCharacteristicChanged(gatt: BluetoothGatt, characteristic: BluetoothGattCharacteristic, value: ByteArray) {
                val asciiStr = String(value, Charsets.UTF_8)
                println("[BLE NOTIFICATION] Received (API 33+): $asciiStr")
            }
        }

        runOnUiThread {
            try {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    device.connectGatt(this@MainActivity, false, gattCallback, BluetoothDevice.TRANSPORT_LE)
                } else {
                    device.connectGatt(this@MainActivity, false, gattCallback)
                }
            } catch (e: Exception) {
                println("[BLE CONNECT] Exception during connectGatt: ${e.message}")
                finishNativeConnect(false, "connectGatt exception: ${e.message}")
            }
        }
    }

    private fun finishNativeConnect(success: Boolean, errorMsg: String?) {
        val res = pendingConnectResult
        pendingConnectResult = null
        if (res != null) {
            runOnUiThread {
                if (success) {
                    res.success(mapOf("isConnected" to true))
                } else {
                    res.success(mapOf("isConnected" to false, "error" to (errorMsg ?: "Connection failed")))
                }
            }
        }
    }

    @Suppress("MissingPermission")
    private fun writeNativeDevice(data: String, result: MethodChannel.Result) {
        val gatt = nativeGatt
        val char = nativeWriteChar

        if (gatt == null || char == null || !isNativeBleConnected) {
            println("[BLE WRITE] Failed: GATT or characteristic is null or disconnected")
            result.success(false)
            return
        }

        // If a previous write is still pending, override/clear it so user commands are never blocked by heartbeats
        if (pendingWriteResult != null) {
            println("[BLE WRITE] Overriding previous pending write for new command: $data")
            try {
                pendingWriteResult?.success(false)
            } catch (_: Exception) {}
            pendingWriteResult = null
        }

        pendingWriteResult = result

        val bytes = data.toByteArray(Charsets.UTF_8)
        val initiated: Boolean = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            val status = gatt.writeCharacteristic(char, bytes, BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT)
            status == 0 // BluetoothStatusCodes.SUCCESS
        } else {
            @Suppress("DEPRECATION")
            char.value = bytes
            @Suppress("DEPRECATION")
            char.writeType = BluetoothGattCharacteristic.WRITE_TYPE_DEFAULT
            @Suppress("DEPRECATION")
            gatt.writeCharacteristic(char)
        }

        if (!initiated) {
            println("[BLE WRITE] writeCharacteristic returned false or status != SUCCESS for: $data")
            pendingWriteResult = null
            result.success(false)
        }
    }

    private fun disconnectNativeDevice() {
        try {
            nativeGatt?.disconnect()
            nativeGatt?.close()
        } catch (_: Exception) {}
        nativeGatt = null
        nativeWriteChar = null
        isNativeBleConnected = false
    }
}

