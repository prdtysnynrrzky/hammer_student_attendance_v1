<?php

namespace App\Http\Controllers;

use App\Models\Attendance;
use Carbon\Carbon;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Validator;

class AttendanceController extends Controller
{
    //
    public function store($rfid): JsonResponse
    {
        $validator = Validator::make(['rfid' => $rfid], [
            'rfid' => 'required|string|min:3',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'meta' => [
                    'code' => 400,
                    'message' => 'RFID minimal 3 karakter!'
                ]
            ], 400);
        }

        try {
            $today = Carbon::today();
            $alreadyCheckedIn = Attendance::where('rfid', $rfid)
                ->whereDate('attendance_time', $today)
                ->exists();

            if ($alreadyCheckedIn) {
                return response()->json([
                    'meta' => [
                        'code' => 400,
                        'message' => 'Anda sudah absen hari ini!'
                    ]
                ], 400);
            }

            Attendance::create(['rfid' => $rfid]);

            return response()->json([
                'meta' => [
                    'code' => 200,
                    'message' => 'Absen berhasil!'
                ]
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'meta' => [
                    'code' => 500,
                    'message' => 'Terjadi kesalahan pada server!'
                ]
            ], 500);
        }
    }
}
